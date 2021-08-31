benchmark "untagged" {
  title = "Untagged"
  children = [
    control.ec2_instance_untagged,
    control.lambda_function_untagged,
    control.s3_bucket_untagged,
  ]
}

query "untagged" {
  title = "Untagged"
  description = "Check which AWS resources are untagged."
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
      -- $1::text
  EOT
  params "table_name" {
    description = "Table name to query."
    # TODO: Is there a default?
    #default = "test"
  }
}

control "lambda_function_untagged" {
  title = "Lambda functions are not untagged"
  query = query.untagged
  params = {
    "table_name" = "aws_lambda_function"
  }
}

control "ec2_instance_untagged" {
  title = "EC2 instances are not untagged"
  query = query.untagged
  params = {
    "table_name" = "aws_ec2_instance"
  }
}

control "s3_bucket_untagged" {
  title = "S3 buckets are not untagged"
  query = query.untagged
  params = {
    "table_name" = "aws_s3_bucket"
  }
}
