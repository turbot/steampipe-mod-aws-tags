variable "sensitive_tags" {
  type        = list(string)
  description = "A list of sensitive tags to check for."
}

locals {
  account_dimensions = "r.account_id"
  region_dimensions  = "r.region, r.account_id"
  sensitive_sql      = <<EOT
    with analysis as (
      select
        arn,
        array_agg(k) as sensitive_tags
      from
        __TABLE_NAME__,
        jsonb_object_keys(tags) as k,
        -- TODO: Change once returned as jsonb intead of json
        --unnest(ARRAY(SELECT jsonb_array_elements_text($1))) as sensitive_key
        unnest(ARRAY(SELECT json_array_elements_text($1))) as sensitive_key
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
      __DIMENSIONS__
    from
      __TABLE_NAME__ as r
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
  title       = "S3 buckets should not have sensitive data in tags"
  description = "Check if S3 buckets have sensitive data in tags based on high risk tag keys."
  sql         = replace(replace(local.sensitive_sql, "__TABLE_NAME__", "aws_s3_bucket"), "__DIMENSIONS__", local.region_dimensions)
  param "sensitive_tags" {
    default = var.sensitive_tags
  }
}

control "ec2_instance_sensitive_data" {
  title       = "EC2 instances should not have sensitive data in tags"
  description = "Check if EC2 instances have sensitive data in tags based on high risk tag keys."
  sql         = replace(replace(local.sensitive_sql, "__TABLE_NAME__", "aws_ec2_instance"), "__DIMENSIONS__", local.region_dimensions)
  param "sensitive_tags" {
    default = var.sensitive_tags
  }
}
