locals {
  untagged_sql = <<EOT
    select
      arn as resource,
      case
        when tags is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when tags is not null then title || ' has tags.'
        else title || ' has no tags.'
      end as reason,
      __DIMENSIONS__
    from
      __TABLE_NAME__
  EOT
}

locals {
  untagged_sql_account = replace(local.untagged_sql, "__DIMENSIONS__", "account_id")
  untagged_sql_region  = replace(local.untagged_sql, "__DIMENSIONS__", "region, account_id")
}

benchmark "untagged" {
  title    = "Untagged"
  description = "Untagged resources are difficult to monitor and should be identified and remediated."
  children = [
    control.ec2_instance_untagged,
    control.iam_role_untagged,
    control.lambda_function_untagged,
    control.s3_bucket_untagged,
  ]
}

control "ec2_instance_untagged" {
  title       = "EC2 instances should be tagged"
  description = "Check if EC2 instances have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_ec2_instance")
}

control "iam_role_untagged" {
  title       = "IAM roles should be tagged"
  description = "Check if IAM roles have at least 1 tag."
  sql         = replace(local.untagged_sql_account, "__TABLE_NAME__", "aws_iam_role")
}

control "lambda_function_untagged" {
  title       = "Lambda functions should be tagged"
  description = "Check if Lambda functions have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_lambda_function")
}

control "s3_bucket_untagged" {
  title       = "S3 buckets should be tagged"
  description = "Check if S3 buckets have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_s3_bucket")
}
