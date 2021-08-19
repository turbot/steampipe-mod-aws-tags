variable "mandatory_tag_keys"{
    type = list(string)
    description = "A list of mandatory tag keys to check for (case sensitive)."
    default = ["Environment", "Owner"]
}

benchmark "mandatory_tag_keys" {
  title = "Mandatory Tag Keys"
  children = [
    control.ec2_instance_mandatory_tag_keys,
    control.s3_bucket_mandatory_tag_keys,
  ]
}

control "s3_bucket_mandatory_tag_keys" {
  title = "S3 buckets have mandatory tags"
  sql = <<EOT
    with input as (
      select array${replace(jsonencode(var.mandatory_tag_keys), "\"", "'")} as mandatory_tag_keys
    ),
    analysis as (
      select
        arn,
        title,
        tags ?& (input.mandatory_tag_keys) as has_mandatory_tag_keys,
        to_jsonb(input.mandatory_tag_keys) - array(select jsonb_object_keys(tags)) as missing_tag_keys,
        region,
        account_id
      from
        aws_s3_bucket,
        input
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

control "ec2_instance_mandatory_tag_keys" {
  title = "EC2 instances have mandatory tags"
  sql = <<EOT
    with input as (
      select array${replace(jsonencode(var.mandatory_tag_keys), "\"", "'")} as mandatory_tag_keys
    ),
    analysis as (
      select
        arn,
        title,
        tags ?& (input.mandatory_tag_keys) as has_mandatory_tag_keys,
        to_jsonb(input.mandatory_tag_keys) - array(select jsonb_object_keys(tags)) as missing_tag_keys,
        region,
        account_id
      from
        aws_ec2_instance,
        input
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
