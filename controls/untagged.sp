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
      region,
      account_id
    from
      __TABLE_NAME__
  EOT
}

benchmark "untagged" {
  title    = "Untagged"
  children = [
    control.ec2_instance_untagged,
    control.lambda_function_untagged,
    control.s3_bucket_untagged,
  ]
}

control "ec2_instance_untagged" {
  title       = "EC2 instances are not untagged"
  description = "Check if EC2 instances have at least 1 tag."
  sql         = replace(local.sql, "__TABLE_NAME__", "aws_ec2_instance")
}

control "lambda_function_untagged" {
  title       = "Lambda functions are not untagged"
  description = "Check if Lambda functions have at least 1 tag."
  sql         = replace(local.sql, "__TABLE_NAME__", "aws_lambda_function")
}

control "s3_bucket_untagged" {
  title       = "S3 buckets are not untagged"
  description = "Check if S3 buckets have at least 1 tag."
  sql         = replace(local.sql, "__TABLE_NAME__", "aws_s3_bucket")
}
