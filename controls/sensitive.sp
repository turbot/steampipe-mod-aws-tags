variable "sensitive_tag_keys" {
    type        = list(string)
    description = "A list of sensitive tag keys to check for (case insensitive)."
    default     = ["key", "password", "private key"]
}

locals {
 sensitive_sql = <<EOT
    with analysis as (
      select
        arn,
        array_agg(k) as sensitive_tags
      from
        input,
        aws_s3_bucket,
        jsonb_object_keys(tags) as k,
        ARRAY(SELECT json_array_elements_text($1)) as sensitive_key
      where
        lower(k) = lower(sensitive_key)
        and k <> sensitive_key
      group by
        arn
    )
    select
      r.arn as resource,
      case
        when a.sensitive_tags <> array[]::text[] then 'alarm'
        else 'ok'
      end as status,
      case
        when a.sensitive_tags <> array[]::text[] then r.title || ' has sensitive tags: ' || array_to_string(a.sensitive_tags, ', ') || '.'
        else r.title || ' has no sensitive tags.'
      end as reason,
      r.region,
      r.account_id
    from
      aws_s3_bucket as r
    full outer join
      analysis as a on a.arn = r.arn
  EOT
}

benchmark "sensitive" {
  title    = "Sensitive"
  children = [
    control.ec2_instance_sensitive_data,
    control.s3_bucket_sensitive_data,
  ]
}

control "s3_bucket_sensitive_data" {
  title       = "S3 buckets do not have sensitive data in tags"
  description = "Check if S3 buckets have sensitive data in tags."
  sql         = replace(local.sensitive_sql, "__TABLE_NAME__", "aws_s3_bucket")
  param "sensitive_tag_keys" {
    default = var.sensitive_tag_keys
  }
}

control "ec2_instance_sensitive_data" {
  title       = "EC2 instances do not have sensitive data in tags"
  description = "Check if EC2 instances have sensitive data in tags."
  sql         = replace(local.sensitive_sql, "__TABLE_NAME__", "aws_ec2_instance")
  param "sensitive_tag_keys" {
    default = var.sensitive_tag_keys
  }
}
