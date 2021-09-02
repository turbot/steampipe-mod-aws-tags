locals {
  account_dimensions = "account_id"
  region_dimensions  = "region, account_id"
  untagged_sql       = <<EOT
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

benchmark "untagged" {
  title    = "Untagged"
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
  sql         = replace(replace(local.untagged_sql, "__TABLE_NAME__", "aws_ec2_instance"), "__DIMENSIONS__", local.region_dimensions)
}

control "iam_role_untagged" {
  title       = "IAM roles should be tagged"
  description = "Check if IAM roles have at least 1 tag."
  sql         = replace(replace(local.untagged_sql, "__TABLE_NAME__", "aws_iam_role"), "__DIMENSIONS__", local.account_dimensions)
}

control "lambda_function_untagged" {
  title       = "Lambda functions should be tagged"
  description = "Check if Lambda functions have at least 1 tag."
  sql         = replace(replace(local.untagged_sql, "__TABLE_NAME__", "aws_lambda_function"), "__DIMENSIONS__", local.region_dimensions)
}

control "s3_bucket_untagged" {
  title       = "S3 buckets should be tagged"
  description = "Check if S3 buckets have at least 1 tag."
  sql         = replace(replace(local.untagged_sql, "__TABLE_NAME__", "aws_s3_bucket"), "__DIMENSIONS__", local.region_dimensions)
}
