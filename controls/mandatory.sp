locals {
  mandatory_tags = ["test", "test1"]
}

benchmark "mandatory" {
  title = "Mandatory"
  children = [
    control.s3_bucket_has_mandatory_tags,
  ]
}

control "s3_bucket_has_mandatory_tags" {
  title = "S3 bucket has mandatory tags"
  sql = <<EOT
    with input as (
      select array${replace(jsonencode(local.mandatory_tags), "\"", "'")} as mandatory_tags
    ),
    analysis as (
      select
        arn,
        name,
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
        when has_mandatory_tags then name || ' has all mandatory tags.'
        else name || ' is missing tags ' || missing_tags
      end as reason,
      name
    from
      analysis
  EOT
}

