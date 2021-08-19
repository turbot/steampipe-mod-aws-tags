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

control "ec2_instance_tag_limit" {
  title = "EC2 instances are not approaching tag limit"
  sql = <<EOT
    with analysis as (
      select
        arn,
        title,
        array_length(array(select jsonb_object_keys(tags)), 1) as num_tag_keys,
        region,
        account_id
      from
        aws_ec2_instance
    )
    select
      arn as resource,
      case
        when num_tag_keys > ${var.tag_warning_limit} then 'alarm'
        else 'ok'
      end as status,
      title || ' has ' || num_tag_keys || ' tags.' as reason,
      region,
      account_id
    from
      analysis
  EOT
}

control "s3_bucket_tag_limit" {
  title = "S3 buckets are not approaching tag limit"
  sql = <<EOT
    with analysis as (
      select
        arn,
        title,
        array_length(array(select jsonb_object_keys(tags)), 1) as num_tag_keys,
        region,
        account_id
      from
        aws_s3_bucket
    )
    select
      arn as resource,
      case
        when num_tag_keys > ${var.tag_warning_limit} then 'alarm'
        else 'ok'
      end as status,
      title || ' has ' || num_tag_keys || ' tags.' as reason,
      region,
      account_id
    from
      analysis
  EOT
}
