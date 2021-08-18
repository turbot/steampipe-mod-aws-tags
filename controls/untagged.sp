benchmark "untagged" {
  title = "Untagged"
  children = [
    control.lambda_function_untagged,
    control.s3_bucket_untagged,
    control.ec2_instance_untagged,
    control.rds_db_instance_untagged,
    control.iam_policy_untagged,
    control.iam_user_untagged,
    control.iam_role_untagged,
    control.vpc_untagged,
    control.vpc_subnet_untagged,
    control.kms_key_untagged,
  ]
}

control "lambda_function_untagged" {
  title = "Lambda Functions Untagged"
  sql = <<EOT
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
      aws_lambda_function
    order by reason
    EOT
}

control "s3_bucket_untagged" {
  title = "S3 Buckets Untagged"
  sql = <<EOT
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
      aws_s3_bucket
    EOT
}

control "ec2_instance_untagged" {
  title = "EC2 Instances Untagged"
  sql = <<EOT
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
      aws_ec2_instance
    EOT
}

control "rds_db_instance_untagged" {
  title = "RDS Database Instances Untagged"
  sql = <<EOT
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
      aws_rds_db_instance
    EOT
}

control "iam_policy_untagged" {
  title = "IAM Policies Untagged"
  sql = <<EOT
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
      aws_iam_policy
    EOT
}

control "iam_user_untagged" {
  title = "IAM Users Untagged"
  sql = <<EOT
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
      aws_iam_user
    EOT
}

control "iam_role_untagged" {
  title = "IAM Roles Untagged"
  sql = <<EOT
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
      aws_iam_role
    EOT
}

control "vpc_untagged" {
  title = "VPC's Untagged"
  sql = <<EOT
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
      aws_vpc
    EOT
}

control "vpc_subnet_untagged" {
  title = "VPC Subnets Untagged"
  sql = <<EOT
    select
      subnet_arn as resource,
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
      aws_vpc_subnet
    EOT
}

control "kms_key_untagged" {
  title = "KMS Keys Untagged"
  sql = <<EOT
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
      aws_kms_key
    EOT
}