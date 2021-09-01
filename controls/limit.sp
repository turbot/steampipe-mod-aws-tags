variable "tag_warning_limit" {
  type        = number
  description = "Number of tags allowed before warning (AWS allows 50 max)."
  default     = 40
}

locals {
  limit_sql = <<EOT
    with analysis as (
      select
        arn,
        title,
        cardinality(array(select jsonb_object_keys(tags))) as num_tag_keys,
        region,
        account_id,
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
      region,
      account_id
    from
      analysis
  EOT
}

benchmark "limit" {
  title    = "Limit"
  children = [
    control.ec2_instance_tag_limit,
    control.s3_bucket_tag_limit
  ]
}

control "ec2_instance_tag_limit" {
  title       = "EC2 instances are not approaching tag limit"
  description = "Check if EC2 instances are approaching the tag limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_ec2_instance")
  param "tag_warning_limit" {
    default = var.tag_warning_limit
  }
}

control "s3_bucket_tag_limit" {
  title       = "S3 buckets are not approaching tag limit"
  description = "Check if S3 buckets are approaching the tag limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_s3_bucket")
  param "tag_warning_limit" {
    default = var.tag_warning_limit
  }
}
