variable "mandatory_tag_keys"{
  type = list(string)
  description = "A list of mandatory tag keys to check for (case sensitive)."
  default = ["Environment", "Owner"]
}

locals {
  sql_query = <<EOT
    with analysis as (
      select
        arn,
        title,
        tags ?& ARRAY(SELECT json_array_elements_text($1)) as has_mandatory_tag_keys,
        -- TODO: Change once it comes in as jsonb
        --$1 - array(select jsonb_object_keys(tags)) as missing_tag_keys,
        to_jsonb($1) - array(select jsonb_object_keys(tags)) as missing_tag_keys,
        region,
        account_id
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
      region,
      account_id
    from
      analysis
  EOT
}

benchmark "mandatory_tag_keys" {
  title = "Mandatory Tag Keys"
  children = [
    control.ec2_instance_mandatory_tag_keys,
    control.s3_bucket_mandatory_tag_keys,
  ]
}

control "ec2_instance_mandatory_tag_keys" {
  title  = "EC2 instances have mandatory tags"
  description = "Check if EC2 instances have mandatory tag keys."
  sql = replace(local.sql_query, "__TABLE_NAME__", "aws_ec2_instance")
  param "mandatory_tag_keys" {
    default = var.mandatory_tag_keys
  }
}

control "s3_bucket_mandatory_tag_keys" {
  title  = "S3 buckets have mandatory tags"
  description = "Check if S3 buckets have mandatory tag keys."
  sql = replace(local.sql_query, "__TABLE_NAME__", "aws_s3_bucket")
  param "mandatory_tag_keys" {
    default = var.mandatory_tag_keys
  }
}
