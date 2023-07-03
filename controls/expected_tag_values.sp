variable "expected_tag_values" {
  type        = map(list(string))
  description = "Map of expected values for various tags, e.g., {\"Environment\": [\"Prod\", \"Staging\", \"Dev%\"]}. SQL wildcards '%' and '_' can be used for matching values. These characters must be escaped for exact matches, e.g., {\"created_by\": [\"test\\_user\"]}."

  default = {
    "Environment": ["Dev", "Staging", "Prod"]
  }
}

locals {
  expected_tag_values_sql = <<-EOQ
  with raw_data as
  (
    select
      arn,
      title,
      tags,
      row_to_json(json_each($1)) as expected_tag_values,
      region,
      account_id,
      _ctx
    from
      __TABLE_NAME__
    where
      tags is not null
  ),
  exploded_expected_tag_values as
  (
    select
      arn,
      title,
      expected_tag_values ->> 'key' as tag_key,
      jsonb_array_elements_text((expected_tag_values ->> 'value')::jsonb) as expected_values,
      tags ->> (expected_tag_values ->> 'key') as current_value,
      region,
      account_id,
      _ctx
    from
      raw_data
  ),
  analysis as
  (
    select
      arn,
      title,
      current_value like expected_values as has_appropriate_value,
      case
        when current_value is null then true
        else false
      end as has_no_matching_tags,
      tag_key,
      current_value,
      region,
      account_id,
      _ctx
    from
      exploded_expected_tag_values
  ),
  status_by_tag as
  (
    select
      arn,
      title,
      bool_or(has_appropriate_value) as status,
      tag_key,
      case
        when bool_or(has_appropriate_value) then ''
        else tag_key
      end as reason,
      bool_or(has_no_matching_tags) as can_skip,
      current_value,
      region,
      account_id,
      _ctx
    from
      analysis
    group by
      arn,
      title,
      tag_key,
      current_value,
      region,
      account_id,
      _ctx
  )
  select
    arn as resource,
    case
      when bool_and(can_skip) then 'skip'
      when bool_and(status) then 'ok'
      else 'alarm'
    end as status,
    case
      when bool_and(can_skip) then title || ' has no matching tag keys.'
      when bool_and(status) then title || ' has expected tag values for tags: ' || array_to_string(array_agg(tag_key) filter(where status), ', ') || '.'
      else title || ' has unexpected tag values for tags: ' || array_to_string(array_agg(tag_key) filter(where not status), ', ') || '.'
    end as reason
    ${local.tag_dimensions_sql}
    ${local.common_dimensions_sql}
  from
    status_by_tag
  group by
    arn,
    title,
    region,
    account_id,
    _ctx
  union all
  select
    arn as resource,
    'skip' as status,
    title || ' has no tags.' as reason
    ${local.tag_dimensions_sql}
    ${local.common_dimensions_sql}
  from
    __TABLE_NAME__
  where
    tags is null
  union all
  select
    arn as resource,
    'skip' as status,
    title || ' has tags but no expected tag values are set.' as reason
    ${local.tag_dimensions_sql}
    ${local.common_dimensions_sql}
  from
    __TABLE_NAME__
  where
    $1::text = '{}'
    and tags is not null
  EOQ
}

benchmark "expected_tag_values" {
  title       = "Expected Tag Values"
  description = "Resources should have specific values for some tags."
  children = [
    control.accessanalyzer_analyzer_expected_tag_values,
    control.api_gateway_stage_expected_tag_values,
    control.cloudfront_distribution_expected_tag_values,
    control.cloudtrail_trail_expected_tag_values,
    control.cloudwatch_alarm_expected_tag_values,
    control.cloudwatch_log_group_expected_tag_values,
    control.codebuild_project_expected_tag_values,
    control.codecommit_repository_expected_tag_values,
    control.codepipeline_pipeline_expected_tag_values,
    control.config_rule_expected_tag_values,
    control.dax_cluster_expected_tag_values,
    control.directory_service_directory_expected_tag_values,
    control.dms_replication_instance_expected_tag_values,
    control.dynamodb_table_expected_tag_values,
    control.ebs_snapshot_expected_tag_values,
    control.ebs_volume_expected_tag_values,
    control.ec2_application_load_balancer_expected_tag_values,
    control.ec2_classic_load_balancer_expected_tag_values,
    control.ec2_gateway_load_balancer_expected_tag_values,
    control.ec2_instance_expected_tag_values,
    control.ec2_network_load_balancer_expected_tag_values,
    control.ec2_reserved_instance_expected_tag_values,
    control.ecr_repository_expected_tag_values,
    control.ecs_container_instance_expected_tag_values,
    control.ecs_service_expected_tag_values,
    control.efs_file_system_expected_tag_values,
    control.eks_addon_expected_tag_values,
    control.eks_cluster_expected_tag_values,
    control.eks_identity_provider_config_expected_tag_values,
    control.elastic_beanstalk_application_expected_tag_values,
    control.elastic_beanstalk_environment_expected_tag_values,
    control.elasticache_cluster_expected_tag_values,
    control.elasticsearch_domain_expected_tag_values,
    control.eventbridge_rule_expected_tag_values,
    control.guardduty_detector_expected_tag_values,
    control.iam_role_expected_tag_values,
    control.iam_server_certificate_expected_tag_values,
    control.iam_user_expected_tag_values,
    control.inspector_assessment_template_expected_tag_values,
    control.kinesis_firehose_delivery_stream_expected_tag_values,
    control.kms_key_expected_tag_values,
    control.lambda_function_expected_tag_values,
    control.rds_db_cluster_expected_tag_values,
    control.rds_db_cluster_parameter_group_expected_tag_values,
    control.rds_db_cluster_snapshot_expected_tag_values,
    control.rds_db_instance_expected_tag_values,
    control.rds_db_option_group_expected_tag_values,
    control.rds_db_parameter_group_expected_tag_values,
    control.rds_db_snapshot_expected_tag_values,
    control.rds_db_subnet_group_expected_tag_values,
    control.redshift_cluster_expected_tag_values,
    control.route53_domain_expected_tag_values,
    control.route53_resolver_endpoint_expected_tag_values,
    control.s3_bucket_expected_tag_values,
    control.sagemaker_endpoint_configuration_expected_tag_values,
    control.sagemaker_model_expected_tag_values,
    control.sagemaker_notebook_instance_expected_tag_values,
    control.sagemaker_training_job_expected_tag_values,
    control.secretsmanager_secret_expected_tag_values,
    control.ssm_parameter_expected_tag_values,
    control.vpc_expected_tag_values,
    control.vpc_eip_expected_tag_values,
    control.vpc_nat_gateway_expected_tag_values,
    control.vpc_network_acl_expected_tag_values,
    control.vpc_security_group_expected_tag_values,
    control.vpc_vpn_connection_expected_tag_values,
    control.wafv2_ip_set_expected_tag_values,
    control.wafv2_regex_pattern_set_expected_tag_values,
    control.wafv2_rule_group_expected_tag_values,
    control.wafv2_web_acl_expected_tag_values
  ]

  tags = merge(local.aws_tags_common_tags, {
    type = "Benchmark"
  })
}

control "accessanalyzer_analyzer_expected_tag_values" {
  title       = "Access Analyzer analyzers should have appropriate tag values"
  description = "Check if Access Analyzer analyzers have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_accessanalyzer_analyzer")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "api_gateway_stage_expected_tag_values" {
  title       = "API Gateway stages should have appropriate tag values"
  description = "Check if API Gateway stages have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_api_gateway_stage")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "cloudfront_distribution_expected_tag_values" {
  title       = "CloudFront distributions should have appropriate tag values"
  description = "Check if CloudFront distributions have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_cloudfront_distribution")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "cloudtrail_trail_expected_tag_values" {
  title       = "CloudTrail trails should have appropriate tag values"
  description = "Check if CloudTrail trails have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_cloudtrail_trail")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "cloudwatch_alarm_expected_tag_values" {
  title       = "CloudWatch alarms should have appropriate tag values"
  description = "Check if CloudWatch alarms have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_cloudwatch_alarm")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "cloudwatch_log_group_expected_tag_values" {
  title       = "CloudWatch log groups should have appropriate tag values"
  description = "Check if CloudWatch log groups have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_cloudwatch_log_group")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "codebuild_project_expected_tag_values" {
  title       = "CodeBuild projects should have appropriate tag values"
  description = "Check if CodeBuild projects have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_codebuild_project")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "codecommit_repository_expected_tag_values" {
  title       = "CodeCommit repositories should have appropriate tag values"
  description = "Check if CodeCommit repositories have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_codecommit_repository")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "codepipeline_pipeline_expected_tag_values" {
  title       = "CodePipeline pipelines should have appropriate tag values"
  description = "Check if CodePipeline pipelines have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_codepipeline_pipeline")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "config_rule_expected_tag_values" {
  title       = "Config rules should have appropriate tag values"
  description = "Check if Config rules have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_config_rule")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "dax_cluster_expected_tag_values" {
  title       = "DAX clusters should have appropriate tag values"
  description = "Check if DAX clusters have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_dax_cluster")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "directory_service_directory_expected_tag_values" {
  title       = "Directory Service directories should have appropriate tag values"
  description = "Check if Directory Service directories have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_directory_service_directory")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "dms_replication_instance_expected_tag_values" {
  title       = "DMS replication instances should have appropriate tag values"
  description = "Check if Dms replication instances have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_dms_replication_instance")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "dynamodb_table_expected_tag_values" {
  title       = "DynamoDB tables should have appropriate tag values"
  description = "Check if DynamoDB tables have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_dynamodb_table")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "ebs_snapshot_expected_tag_values" {
  title       = "EBS snapshots should have appropriate tag values"
  description = "Check if EBS snapshots have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_ebs_snapshot")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "ebs_volume_expected_tag_values" {
  title       = "EBS volumes should have appropriate tag values"
  description = "Check if EBS volumes have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_ebs_volume")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "ec2_application_load_balancer_expected_tag_values" {
  title       = "EC2 application load balancers should have appropriate tag values"
  description = "Check if EC2 application load balancers have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_ec2_application_load_balancer")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "ec2_classic_load_balancer_expected_tag_values" {
  title       = "EC2 classic load balancers should have appropriate tag values"
  description = "Check if EC2 classic load balancers have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_ec2_classic_load_balancer")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "ec2_gateway_load_balancer_expected_tag_values" {
  title       = "EC2 gateway load balancers should have appropriate tag values"
  description = "Check if EC2 gateway load balancers have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_ec2_gateway_load_balancer")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "ec2_instance_expected_tag_values" {
  title       = "EC2 instances should have appropriate tag values"
  description = "Check if EC2 instances have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_ec2_instance")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "ec2_network_load_balancer_expected_tag_values" {
  title       = "EC2 network load balancers should have appropriate tag values"
  description = "Check if EC2 network load balancers have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_ec2_network_load_balancer")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "ec2_reserved_instance_expected_tag_values" {
  title       = "EC2 reserved instances should have appropriate tag values"
  description = "Check if EC2 reserved instances have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_ec2_reserved_instance")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "ecr_repository_expected_tag_values" {
  title       = "ECR repositories should have appropriate tag values"
  description = "Check if ECR repositories have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_ecr_repository")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "ecs_container_instance_expected_tag_values" {
  title       = "ECS container instances should have appropriate tag values"
  description = "Check if ECS container instances have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_ecs_container_instance")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "ecs_service_expected_tag_values" {
  title       = "ECS services should have appropriate tag values"
  description = "Check if ECS services have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_ecs_service")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "efs_file_system_expected_tag_values" {
  title       = "EFS file systems should have appropriate tag values"
  description = "Check if EFS file systems have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_efs_file_system")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "eks_addon_expected_tag_values" {
  title       = "EKS addons should have appropriate tag values"
  description = "Check if EKS addons have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_eks_addon")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "eks_cluster_expected_tag_values" {
  title       = "EKS clusters should have appropriate tag values"
  description = "Check if EKS clusters have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_eks_cluster")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "eks_identity_provider_config_expected_tag_values" {
  title       = "EKS identity provider configs should have appropriate tag values"
  description = "Check if EKS identity provider configs have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_eks_identity_provider_config")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "elastic_beanstalk_application_expected_tag_values" {
  title       = "Elastic beanstalk applications should have appropriate tag values"
  description = "Check if Elastic beanstalk applications have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_elastic_beanstalk_application")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "elastic_beanstalk_environment_expected_tag_values" {
  title       = "Elastic beanstalk environments should have appropriate tag values"
  description = "Check if Elastic beanstalk environments have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_elastic_beanstalk_environment")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "elasticache_cluster_expected_tag_values" {
  title       = "ElastiCache clusters should have appropriate tag values"
  description = "Check if ElastiCache clusters have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_elasticache_cluster")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "elasticsearch_domain_expected_tag_values" {
  title       = "ElasticSearch domains should have appropriate tag values"
  description = "Check if ElasticSearch domains have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_elasticsearch_domain")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "eventbridge_rule_expected_tag_values" {
  title       = "EventBridge rules should have appropriate tag values"
  description = "Check if EventBridge rules have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_eventbridge_rule")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "guardduty_detector_expected_tag_values" {
  title       = "GuardDuty detectors should have appropriate tag values"
  description = "Check if GuardDuty detectors have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_guardduty_detector")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "iam_role_expected_tag_values" {
  title       = "IAM roles should have appropriate tag values"
  description = "Check if IAM roles have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_iam_role")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "iam_server_certificate_expected_tag_values" {
  title       = "IAM server certificates should have appropriate tag values"
  description = "Check if IAM server certificates have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_iam_server_certificate")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "iam_user_expected_tag_values" {
  title       = "IAM users should have appropriate tag values"
  description = "Check if IAM users have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_iam_user")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "inspector_assessment_template_expected_tag_values" {
  title       = "Inspector assessment templates should have appropriate tag values"
  description = "Check if Inspector assessment templates have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_inspector_assessment_template")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "kinesis_firehose_delivery_stream_expected_tag_values" {
  title       = "Kinesis firehose delivery streams should have appropriate tag values"
  description = "Check if Kinesis firehose delivery streams have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_kinesis_firehose_delivery_stream")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "kms_key_expected_tag_values" {
  title       = "KMS keys should have appropriate tag values"
  description = "Check if KMS keys have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_kms_key")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "lambda_function_expected_tag_values" {
  title       = "Lambda functions should have appropriate tag values"
  description = "Check if Lambda functions have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_lambda_function")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "rds_db_cluster_expected_tag_values" {
  title       = "RDS DB clusters should have appropriate tag values"
  description = "Check if RDS DB clusters have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_rds_db_cluster")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "rds_db_cluster_parameter_group_expected_tag_values" {
  title       = "RDS DB cluster parameter groups should have appropriate tag values"
  description = "Check if RDS DB cluster parameter groups have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_rds_db_cluster_parameter_group")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "rds_db_cluster_snapshot_expected_tag_values" {
  title       = "RDS DB cluster snapshots should have appropriate tag values"
  description = "Check if RDS DB cluster snapshots have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_rds_db_cluster_snapshot")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "rds_db_instance_expected_tag_values" {
  title       = "RDS DB instances should have appropriate tag values"
  description = "Check if RDS DB instances have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_rds_db_instance")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "rds_db_option_group_expected_tag_values" {
  title       = "RDS DB option groups should have appropriate tag values"
  description = "Check if RDS DB option groups have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_rds_db_option_group")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "rds_db_parameter_group_expected_tag_values" {
  title       = "RDS DB parameter groups should have appropriate tag values"
  description = "Check if RDS DB parameter groups have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_rds_db_parameter_group")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "rds_db_snapshot_expected_tag_values" {
  title       = "RDS DB snapshots should have appropriate tag values"
  description = "Check if RDS DB snapshots have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_rds_db_snapshot")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "rds_db_subnet_group_expected_tag_values" {
  title       = "RDS DB subnet groups should have appropriate tag values"
  description = "Check if RDS DB subnet groups have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_rds_db_subnet_group")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "redshift_cluster_expected_tag_values" {
  title       = "Redshift clusters should have appropriate tag values"
  description = "Check if Redshift clusters have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_redshift_cluster")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "route53_domain_expected_tag_values" {
  title       = "Route53 domains should have appropriate tag values"
  description = "Check if Route53 domains have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_route53_domain")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "route53_resolver_endpoint_expected_tag_values" {
  title       = "Route 53 Resolver endpoints should have appropriate tag values"
  description = "Check if Route 53 Resolver endpoints have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_route53_resolver_endpoint")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "s3_bucket_expected_tag_values" {
  title       = "S3 buckets should have appropriate tag values"
  description = "Check if S3 buckets have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_s3_bucket")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "sagemaker_endpoint_configuration_expected_tag_values" {
  title       = "SageMaker endpoint configurations should have appropriate tag values"
  description = "Check if SageMaker endpoint configurations have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_sagemaker_endpoint_configuration")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "sagemaker_model_expected_tag_values" {
  title       = "SageMaker models should have appropriate tag values"
  description = "Check if SageMaker models have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_sagemaker_model")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "sagemaker_notebook_instance_expected_tag_values" {
  title       = "SageMaker notebook instances should have appropriate tag values"
  description = "Check if SageMaker notebook instances have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_sagemaker_notebook_instance")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "sagemaker_training_job_expected_tag_values" {
  title       = "SageMaker training jobs should have appropriate tag values"
  description = "Check if SageMaker training jobs have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_sagemaker_training_job")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "secretsmanager_secret_expected_tag_values" {
  title       = "Secrets Manager secrets should have appropriate tag values"
  description = "Check if Secrets Manager secrets have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_secretsmanager_secret")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "ssm_parameter_expected_tag_values" {
  title       = "SSM parameters should have appropriate tag values"
  description = "Check if SSM parameters have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_ssm_parameter")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "vpc_expected_tag_values" {
  title       = "VPCs should have appropriate tag values"
  description = "Check if VPCs have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_vpc")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "vpc_eip_expected_tag_values" {
  title       = "VPC elastic IP addresses should have appropriate tag values"
  description = "Check if VPC elastic IP addresses have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_vpc_eip")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "vpc_nat_gateway_expected_tag_values" {
  title       = "VPC NAT gateways should have appropriate tag values"
  description = "Check if VPC NAT gateways have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_vpc_nat_gateway")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "vpc_network_acl_expected_tag_values" {
  title       = "VPC network ACLs should have appropriate tag values"
  description = "Check if VPC network ACLs have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_vpc_network_acl")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "vpc_security_group_expected_tag_values" {
  title       = "VPC security groups should have appropriate tag values"
  description = "Check if VPC security groups have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_vpc_security_group")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "vpc_vpn_connection_expected_tag_values" {
  title       = "VPC VPN connections should have appropriate tag values"
  description = "Check if VPC VPN connections have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_vpc_vpn_connection")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "wafv2_ip_set_expected_tag_values" {
  title       = "WAFV2 ip sets should have appropriate tag values"
  description = "Check if WAFV2 ip sets have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_wafv2_ip_set")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "wafv2_regex_pattern_set_expected_tag_values" {
  title       = "WAFV2 regex pattern sets should have appropriate tag values"
  description = "Check if WAFV2 regex pattern sets have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_wafv2_regex_pattern_set")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "wafv2_rule_group_expected_tag_values" {
  title       = "WAFV2 rule groups should have appropriate tag values"
  description = "Check if WAFV2 rule groups have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_wafv2_rule_group")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "wafv2_web_acl_expected_tag_values" {
  title       = "WAFV2 web acls should have appropriate tag values"
  description = "Check if WAFV2 web acls have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql, "__TABLE_NAME__", "aws_wafv2_web_acl")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}
