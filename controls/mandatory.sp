variable "mandatory_tags" {
  type        = list(string)
  description = "A list of mandatory tags to check for."
}

locals {
  account_dimensions = "account_id"
  region_dimensions  = "region, account_id"
  mandatory_sql      = <<EOT
    with analysis as (
      select
        arn,
        title,
        tags ?& ARRAY(SELECT json_array_elements_text($1)) as has_mandatory_tags,
        -- TODO: Change after they are returned as jsonb
        --$1 - array(select jsonb_object_keys(tags)) as missing_tags,
        to_jsonb($1) - array(select jsonb_object_keys(tags)) as missing_tags,
        __DIMENSIONS__
      from
        __TABLE_NAME__
    )
    select
      arn as resource,
      case
        when has_mandatory_tags then 'ok'
        else 'alarm'
      end as status,
      case
        when has_mandatory_tags then title || ' has all mandatory tags.'
        else title || ' is missing tags ' || missing_tags
      end as reason,
      __DIMENSIONS__
    from
      analysis
  EOT
}

benchmark "mandatory" {
  title       = "Mandatory"
  description = "Resources should all have a standard set of tags applied for functions like resource organization, automation, cost control, and access control."
  children = [
    control.ec2_instance_mandatory,
    control.iam_role_mandatory,
    control.s3_bucket_mandatory,
  ]
}

control "ec2_instance_mandatory" {
  title       = "EC2 instances should have mandatory tags"
  description = "Check if EC2 instances have mandatory tags."
  sql         = replace(replace(local.mandatory_sql, "__TABLE_NAME__", "aws_ec2_instance"), "__DIMENSIONS__", local.region_dimensions)
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "iam_role_mandatory" {
  title       = "IAM roles should have mandatory tags"
  description = "Check if IAM roles have mandatory tags."
  sql         = replace(replace(local.mandatory_sql, "__TABLE_NAME__", "aws_iam_role"), "__DIMENSIONS__", local.account_dimensions)
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "lambda_function_mandatory" {
  title       = "Lambda functions should have mandatory tags"
  description = "Check if Lambda functions have mandatory tags."
  sql         = replace(replace(local.mandatory_sql, "__TABLE_NAME__", "aws_lambda_function"), "__DIMENSIONS__", local.region_dimensions)
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}


control "s3_bucket_mandatory" {
  title       = "S3 buckets should have mandatory tags"
  description = "Check if S3 buckets have mandatory tags."
  sql         = replace(replace(local.mandatory_sql, "__TABLE_NAME__", "aws_s3_bucket"), "__DIMENSIONS__", local.region_dimensions)
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}
