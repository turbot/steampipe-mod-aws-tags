variable "prohibited_tags" {
  type        = list(string)
  description = "A list of prohibited tags to check for."
}

locals {
  prohibited_sql = <<EOT
    with analysis as (
      select
        arn,
        array_agg(k) as prohibited_tags
      from
        __TABLE_NAME__,
        jsonb_object_keys(tags) as k,
        -- TODO: Change once returned as jsonb intead of json
        --unnest(array(select jsonb_array_elements_text($1))) as prohibited_key
        unnest(array(select json_array_elements_text($1))) as prohibited_key
      where
        k = prohibited_key
      group by
        arn
    )
    select
      r.arn as resource,
      case
        when a.prohibited_tags <> array[]::text[] then 'alarm'
        else 'ok'
      end as status,
      case
        when a.prohibited_tags <> array[]::text[] then r.title || ' has prohibited tags: ' || array_to_string(a.prohibited_tags, ', ') || '.'
        else r.title || ' has no prohibited tags.'
      end as reason,
      __DIMENSIONS__
    from
      __TABLE_NAME__ as r
    full outer join
      analysis as a on a.arn = r.arn
  EOT
}

locals {
  prohibited_sql_account = replace(local.prohibited_sql, "__DIMENSIONS__", "account_id")
  prohibited_sql_region  = replace(local.prohibited_sql, "__DIMENSIONS__", "region, account_id")
}

benchmark "prohibited" {
  title    = "Prohibited"
  description = "Prohibited tags may contain sensitive, confidential, or otherwise unwanted data and should be removed."
  children = [
    control.ec2_instance_prohibited,
    control.s3_bucket_prohibited,
  ]
}

control "ec2_instance_prohibited" {
  title       = "EC2 instances should not have prohibited tags"
  description = "Check if EC2 instances have any prohibited tags."
  sql         = replace(local.prohibited_sql_region, "__TABLE_NAME__", "aws_ec2_instance")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "s3_bucket_prohibited" {
  title       = "S3 buckets should not have prohibited tags"
  description = "Check if S3 buckets have any prohibited tags."
  sql         = replace(local.prohibited_sql_region, "__TABLE_NAME__", "aws_s3_bucket")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}
