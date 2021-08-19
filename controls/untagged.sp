benchmark "untagged" {
  title = "Untagged"
  children = [
    control.lambda_function_untagged,
    control.s3_bucket_untagged,
  ]
}

control "lambda_function_untagged" {
  title = "Lambda functions are not untagged"
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
  title = "S3 buckets are not untagged"
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
