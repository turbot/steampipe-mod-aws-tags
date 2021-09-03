variable "tag_limit" {
  type        = number
  description = "Number of tags allowed on a resource. AWS allows up to 50 tags per resource."
}

locals {
  limit_sql = <<EOT
    with analysis as (
      select
        arn,
        title,
        cardinality(array(select jsonb_object_keys(tags))) as num_tag_keys,
        __DIMENSIONS__
      from
        __TABLE_NAME__
    )
    select
      arn as resource,
      case
        when num_tag_keys > $1::integer then 'alarm'
        else 'ok'
      end as status,
      title || ' has ' || num_tag_keys || ' tags.' as reason,
      __DIMENSIONS__
    from
      analysis
  EOT
}

locals {
  limit_sql_account = replace(local.limit_sql, "__DIMENSIONS__", "account_id")
  limit_sql_region  = replace(local.limit_sql, "__DIMENSIONS__", "region, account_id")
}

benchmark "limit" {
  title       = "Limit"
  description = "The number of tags on each resource should be monitored to avoid hitting the limit unexpectedly."
  children = [
    control.ec2_instance_tag_limit,
    control.s3_bucket_tag_limit
  ]
}

control "ec2_instance_tag_limit" {
  title       = "EC2 instances should not exceed tag limit"
  description = "Check if the number of tags on EC2 instances do not exceed the limit."
  sql         = replace(local.limit_sql_region, "__TABLE_NAME__", "aws_ec2_instance")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "s3_bucket_tag_limit" {
  title       = "S3 buckets should not exceed tag limit"
  description = "Check if the number of tags on S3 buckets do not exceed the limit."
  sql         = replace(local.limit_sql_region, "__TABLE_NAME__", "aws_s3_bucket")
  param "tag_limit" {
    default = var.tag_limit
  }
}
