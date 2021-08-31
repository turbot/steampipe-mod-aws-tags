variable "tag_warning_limit" {
  type        = number
  description = "Number of tags allowed before warning (AWS allows 50 max)."
  default     = 40
}

benchmark "limit" {
  title = "Limit"
  children = [
    control.ec2_instance_tag_limit,
    control.s3_bucket_tag_limit
  ]
}

query "tag_warning_limit" {
  title = "Tag Warning Limit"
  description = "Check which AWS resources are approaching the tag limit."
  sql = <<EOT
    with analysis as (
      select
        arn,
        title,
        cardinality(array(select jsonb_object_keys(tags))) as num_tag_keys,
        region,
        account_id,
      from
        aws_ec2_instance
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
  params "tag_warning_limit" {
    description = "Number of allowed before warning (AWS allows max 50)."
    default     = var.tag_warning_limit
  }
}

control "ec2_instance_tag_limit" {
  title = "EC2 instances are not approaching tag limit"
  query = query.tag_warning_limit
  params = {
    "table_name" = "aws_ec2_instance"
  }
}

control "s3_bucket_tag_limit" {
  title = "S3 buckets are not approaching tag limit"
  query = query.tag_warning_limit
  params = {
    "table_name" = "aws_s3_bucket"
  }
}
