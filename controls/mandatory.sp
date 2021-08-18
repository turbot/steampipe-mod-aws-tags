locals {
  mandatory_tags = ["test", "test1"]
}

benchmark "mandatory" {
  title = "Mandatory"
  children = [
    control.s3_bucket_has_mandatory_tags,
    control.lambda_function_has_mandatory_tags,
    control.ec2_instance_has_mandatory_tags,
    control.rds_db_instance_has_mandatory_tags,
    control.iam_policy_has_mandatory_tags,
    control.iam_user_has_mandatory_tags,
    control.iam_role_has_mandatory_tags,
    control.vpc_has_mandatory_tags,
    control.vpc_subnet_has_mandatory_tags,
    control.kms_key_has_mandatory_tags,
  ]
}

control "s3_bucket_has_mandatory_tags" {
  title = "S3 Buckets have mandatory tags"
  sql = <<EOT
    with input as (
      select array${replace(jsonencode(local.mandatory_tags), "\"", "'")} as mandatory_tags
    ),
    analysis as (
      select
        arn,
        title,
        tags ?& (input.mandatory_tags) as has_mandatory_tags,
        to_jsonb(input.mandatory_tags) - array(select jsonb_object_keys(tags)) as missing_tags,
        region,
        account_id
      from
        aws_s3_bucket,
        input
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
      title
    from
      analysis
  EOT
}

control "lambda_function_has_mandatory_tags" {
  title = "Lambda Functions have mandatory tags"
  sql = <<EOT
    with input as (
      select array${replace(jsonencode(local.mandatory_tags), "\"", "'")} as mandatory_tags
    ),
    analysis as (
      select
        arn,
        title,
        tags ?& (input.mandatory_tags) as has_mandatory_tags,
        to_jsonb(input.mandatory_tags) - array(select jsonb_object_keys(tags)) as missing_tags,
        region,
        account_id
      from
        aws_lambda_function,
        input
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
      title
    from
      analysis
  EOT
}

control "ec2_instance_has_mandatory_tags" {
  title = "EC2 Instances have mandatory tags"
  sql = <<EOT
    with input as (
      select array${replace(jsonencode(local.mandatory_tags), "\"", "'")} as mandatory_tags
    ),
    analysis as (
      select
        arn,
        title,
        tags ?& (input.mandatory_tags) as has_mandatory_tags,
        to_jsonb(input.mandatory_tags) - array(select jsonb_object_keys(tags)) as missing_tags,
        region,
        account_id
      from
        aws_ec2_instance,
        input
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
      title
    from
      analysis
  EOT
}

control "rds_db_instance_has_mandatory_tags" {
  title = "RDS Database Instances have mandatory tags"
  sql = <<EOT
    with input as (
      select array${replace(jsonencode(local.mandatory_tags), "\"", "'")} as mandatory_tags
    ),
    analysis as (
      select
        arn,
        title,
        tags ?& (input.mandatory_tags) as has_mandatory_tags,
        to_jsonb(input.mandatory_tags) - array(select jsonb_object_keys(tags)) as missing_tags,
        region,
        account_id
      from
        aws_rds_db_instance,
        input
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
      title
    from
      analysis
  EOT
}

control "iam_policy_has_mandatory_tags" {
  title = "IAM Policies have mandatory tags"
  sql = <<EOT
    with input as (
      select array${replace(jsonencode(local.mandatory_tags), "\"", "'")} as mandatory_tags
    ),
    analysis as (
      select
        arn,
        title,
        tags ?& (input.mandatory_tags) as has_mandatory_tags,
        to_jsonb(input.mandatory_tags) - array(select jsonb_object_keys(tags)) as missing_tags,
        region,
        account_id
      from
        aws_iam_policy,
        input
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
      title
    from
      analysis
  EOT
}

control "iam_user_has_mandatory_tags" {
  title = "IAM Users have mandatory tags"
  sql = <<EOT
    with input as (
      select array${replace(jsonencode(local.mandatory_tags), "\"", "'")} as mandatory_tags
    ),
    analysis as (
      select
        arn,
        title,
        tags ?& (input.mandatory_tags) as has_mandatory_tags,
        to_jsonb(input.mandatory_tags) - array(select jsonb_object_keys(tags)) as missing_tags,
        region,
        account_id
      from
        aws_iam_user,
        input
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
      title
    from
      analysis
  EOT
}

control "iam_role_has_mandatory_tags" {
  title = "IAM Roles have mandatory tags"
  sql = <<EOT
    with input as (
      select array${replace(jsonencode(local.mandatory_tags), "\"", "'")} as mandatory_tags
    ),
    analysis as (
      select
        arn,
        title,
        tags ?& (input.mandatory_tags) as has_mandatory_tags,
        to_jsonb(input.mandatory_tags) - array(select jsonb_object_keys(tags)) as missing_tags,
        region,
        account_id
      from
        aws_iam_role,
        input
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
      title
    from
      analysis
  EOT
}

control "vpc_has_mandatory_tags" {
  title = "VPC's have mandatory tags"
  sql = <<EOT
    with input as (
      select array${replace(jsonencode(local.mandatory_tags), "\"", "'")} as mandatory_tags
    ),
    analysis as (
      select
        arn,
        title,
        tags ?& (input.mandatory_tags) as has_mandatory_tags,
        to_jsonb(input.mandatory_tags) - array(select jsonb_object_keys(tags)) as missing_tags,
        region,
        account_id
      from
        aws_vpc,
        input
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
      title
    from
      analysis
  EOT
}

control "vpc_subnet_has_mandatory_tags" {
  title = "VPC Subnets have mandatory tags"
  sql = <<EOT
    with input as (
      select array${replace(jsonencode(local.mandatory_tags), "\"", "'")} as mandatory_tags
    ),
    analysis as (
      select
        subnet_arn,
        title,
        tags ?& (input.mandatory_tags) as has_mandatory_tags,
        to_jsonb(input.mandatory_tags) - array(select jsonb_object_keys(tags)) as missing_tags,
        region,
        account_id
      from
        aws_vpc_subnet,
        input
    )
    select
      subnet_arn as resource,
      case
        when has_mandatory_tags then 'ok'
        else 'alarm'
      end as status,
      case
        when has_mandatory_tags then title || ' has all mandatory tags.'
        else title || ' is missing tags ' || missing_tags
      end as reason,
      title
    from
      analysis
  EOT
}

control "kms_key_has_mandatory_tags" {
  title = "KMS Keys have mandatory tags"
  sql = <<EOT
    with input as (
      select array${replace(jsonencode(local.mandatory_tags), "\"", "'")} as mandatory_tags
    ),
    analysis as (
      select
        arn,
        title,
        tags ?& (input.mandatory_tags) as has_mandatory_tags,
        to_jsonb(input.mandatory_tags) - array(select jsonb_object_keys(tags)) as missing_tags,
        region,
        account_id
      from
        aws_kms_key,
        input
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
      title
    from
      analysis
  EOT
}