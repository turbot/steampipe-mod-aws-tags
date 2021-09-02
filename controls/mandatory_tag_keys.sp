variable "mandatory_tag_keys"{
  type        = list(string)
  description = "A list of mandatory tag keys to check for (case sensitive)."
  default     = ["Environment", "Owner"]
}

locals {
  account_dimensions     = "account_id"
  region_dimensions      = "region, account_id"
  mandatory_tag_keys_sql = <<EOT
    with analysis as (
      select
        arn,
        title,
        tags ?& ARRAY(SELECT json_array_elements_text($1)) as has_mandatory_tag_keys,
        $1 - array(select jsonb_object_keys(tags)) as missing_tag_keys,
        -- TODO: Remove after testing
        --to_jsonb($1) - array(select jsonb_object_keys(tags)) as missing_tag_keys,
        __DIMENSIONS__
      from
        __TABLE_NAME__
    )
    select
      arn as resource,
      case
        when has_mandatory_tag_keys then 'ok'
        else 'alarm'
      end as status,
      case
        when has_mandatory_tag_keys then title || ' has all mandatory tags.'
        else title || ' is missing tag keys ' || missing_tag_keys
      end as reason,
      __DIMENSIONS__
    from
      analysis
  EOT
}

benchmark "mandatory_tag_keys" {
  title    = "Mandatory Tag Keys"
  children = [
    control.ec2_instance_mandatory_tag_keys,
    control.iam_role_mandatory_tag_keys,
    control.s3_bucket_mandatory_tag_keys,
  ]
}

control "ec2_instance_mandatory_tag_keys" {
  title       = "EC2 instances have mandatory tags"
  description = "Check if EC2 instances have mandatory tag keys."
  sql         = replace(replace(local.mandatory_tag_keys_sql, "__TABLE_NAME__", "aws_ec2_instance"), "__DIMENSIONS__", local.region_dimensions)
  param "mandatory_tag_keys" {
    default = var.mandatory_tag_keys
  }
}

control "iam_role_mandatory_tag_keys" {
  title       = "IAM roles have mandatory tags"
  description = "Check if IAM roles have mandatory tag keys."
  sql         = replace(replace(local.mandatory_tag_keys_sql, "__TABLE_NAME__", "aws_iam_role"), "__DIMENSIONS__", local.region_dimensions)
  param "mandatory_tag_keys" {
    default = var.mandatory_tag_keys
  }
}

control "s3_bucket_mandatory_tag_keys" {
  title       = "S3 buckets have mandatory tags"
  description = "Check if S3 buckets have mandatory tag keys."
  sql         = replace(replace(local.mandatory_tag_keys_sql, "__TABLE_NAME__", "aws_s3_bucket"), "__DIMENSIONS__", local.region_dimensions)
  param "mandatory_tag_keys" {
    default = var.mandatory_tag_keys
  }
}
