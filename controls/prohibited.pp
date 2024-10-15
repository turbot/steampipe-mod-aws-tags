variable "prohibited_tags" {
  type        = list(string)
  description = "A list of prohibited tags to check for."
  default     = ["Password", "Key"]
}

locals {
  prohibited_sql = <<-EOQ
    with analysis as (
      select
        arn,
        array_agg(k) as prohibited_tags,
        region,
        account_id,
        tags,
        _ctx
      from
        __TABLE_NAME__,
        jsonb_object_keys(tags) as k,
        unnest($1::text[]) as prohibited_key
      where
        k = prohibited_key
      group by
        arn,
        region,
        account_id,
        tags,
        _ctx
    )
    select
      r.arn as resource,
      case
        when a.prohibited_tags <> array[]::text[] then 'alarm'
        else 'ok'
      end as status,
      case
        when a.prohibited_tags <> array[]::text[] then r.title || ' has prohibited tags: ' || array_to_string(a.prohibited_tags, ', ') || '.'
        else r.title || ' has no prohibited tags.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "r.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "r.")}
    from
      __TABLE_NAME__ as r
    full outer join
      analysis as a on a.arn = r.arn;
  EOQ
}

benchmark "prohibited" {
  title       = "Prohibited"
  description = "Prohibited tags may contain sensitive, confidential, or otherwise unwanted data and should be removed."
  children = [
    control.accessanalyzer_analyzer_prohibited,
    control.api_gateway_stage_prohibited,
    control.cloudfront_distribution_prohibited,
    control.cloudtrail_trail_prohibited,
    control.cloudwatch_alarm_prohibited,
    control.cloudwatch_log_group_prohibited,
    control.codebuild_project_prohibited,
    control.codecommit_repository_prohibited,
    control.codepipeline_pipeline_prohibited,
    control.config_rule_prohibited,
    control.dax_cluster_prohibited,
    control.directory_service_directory_prohibited,
    control.dms_replication_instance_prohibited,
    control.dynamodb_table_prohibited,
    control.ebs_snapshot_prohibited,
    control.ebs_volume_prohibited,
    control.ec2_application_load_balancer_prohibited,
    control.ec2_classic_load_balancer_prohibited,
    control.ec2_gateway_load_balancer_prohibited,
    control.ec2_instance_prohibited,
    control.ec2_network_load_balancer_prohibited,
    control.ec2_reserved_instance_prohibited,
    control.ecr_repository_prohibited,
    control.ecs_container_instance_prohibited,
    control.ecs_service_prohibited,
    control.efs_file_system_prohibited,
    control.eks_addon_prohibited,
    control.eks_cluster_prohibited,
    control.eks_identity_provider_config_prohibited,
    control.elastic_beanstalk_application_prohibited,
    control.elastic_beanstalk_environment_prohibited,
    control.elasticache_cluster_prohibited,
    control.elasticsearch_domain_prohibited,
    control.eventbridge_rule_prohibited,
    control.guardduty_detector_prohibited,
    control.iam_role_prohibited,
    control.iam_server_certificate_prohibited,
    control.iam_user_prohibited,
    control.inspector_assessment_template_prohibited,
    control.kinesis_firehose_delivery_stream_prohibited,
    control.kms_key_prohibited,
    control.lambda_function_prohibited,
    control.rds_db_cluster_parameter_group_prohibited,
    control.rds_db_cluster_prohibited,
    control.rds_db_cluster_snapshot_prohibited,
    control.rds_db_instance_prohibited,
    control.rds_db_option_group_prohibited,
    control.rds_db_parameter_group_prohibited,
    control.rds_db_snapshot_prohibited,
    control.rds_db_subnet_group_prohibited,
    control.redshift_cluster_prohibited,
    control.route53_domain_prohibited,
    control.route53_resolver_endpoint_prohibited,
    control.s3_bucket_prohibited,
    control.sagemaker_endpoint_configuration_prohibited,
    control.sagemaker_model_prohibited,
    control.sagemaker_notebook_instance_prohibited,
    control.sagemaker_training_job_prohibited,
    control.secretsmanager_secret_prohibited,
    control.ssm_parameter_prohibited,
    control.vpc_eip_prohibited,
    control.vpc_nat_gateway_prohibited,
    control.vpc_network_acl_prohibited,
    control.vpc_prohibited,
    control.vpc_security_group_prohibited,
    control.vpc_vpn_connection_prohibited,
    control.wafv2_ip_set_prohibited,
    control.wafv2_regex_pattern_set_prohibited,
    control.wafv2_rule_group_prohibited,
    control.wafv2_web_acl_prohibited
  ]

  tags = merge(local.aws_tags_common_tags, {
    type = "Benchmark"
  })
}

control "accessanalyzer_analyzer_prohibited" {
  title       = "Access Analyzer analyzers should not have prohibited tags"
  description = "Check if Access Analyzer analyzers have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_accessanalyzer_analyzer")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "api_gateway_stage_prohibited" {
  title       = "API Gateway stages should not have prohibited tags"
  description = "Check if API Gateway stages have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_api_gateway_stage")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "cloudfront_distribution_prohibited" {
  title       = "CloudFront distributions should not have prohibited tags"
  description = "Check if CloudFront distributions have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_cloudfront_distribution")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "cloudtrail_trail_prohibited" {
  title       = "CloudTrail trails should not have prohibited tags"
  description = "Check if CloudTrail trails have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_cloudtrail_trail")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "cloudwatch_alarm_prohibited" {
  title       = "CloudWatch alarms should not have prohibited tags"
  description = "Check if CloudWatch alarms have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_cloudwatch_alarm")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "cloudwatch_log_group_prohibited" {
  title       = "CloudWatch log groups should not have prohibited tags"
  description = "Check if CloudWatch log groups have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_cloudwatch_log_group")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "codebuild_project_prohibited" {
  title       = "CodeBuild projects should not have prohibited tags"
  description = "Check if CodeBuild projects have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_codebuild_project")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "codecommit_repository_prohibited" {
  title       = "CodeCommit repositories should not have prohibited tags"
  description = "Check if CodeCommit repositories have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_codecommit_repository")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "codepipeline_pipeline_prohibited" {
  title       = "CodePipeline pipelines should not have prohibited tags"
  description = "Check if CodePipeline pipelines have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_codepipeline_pipeline")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "config_rule_prohibited" {
  title       = "Config rules should not have prohibited tags"
  description = "Check if Config rules have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_config_rule")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "dax_cluster_prohibited" {
  title       = "DAX clusters should not have prohibited tags"
  description = "Check if DAX clusters have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_dax_cluster")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "directory_service_directory_prohibited" {
  title       = "Directory Service directories should not have prohibited tags"
  description = "Check if Directory Service directories have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_directory_service_directory")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "dms_replication_instance_prohibited" {
  title       = "DMS replication instances should not have prohibited tags"
  description = "Check if DMS replication instances have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_dms_replication_instance")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "dynamodb_table_prohibited" {
  title       = "DynamoDB tables should not have prohibited tags"
  description = "Check if DynamoDB tables have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_dynamodb_table")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "ebs_snapshot_prohibited" {
  title       = "EBS snapshots should not have prohibited tags"
  description = "Check if EBS snapshots have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_ebs_snapshot")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "ebs_volume_prohibited" {
  title       = "EBS volumes should not have prohibited tags"
  description = "Check if EBS volumes have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_ebs_volume")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "ec2_application_load_balancer_prohibited" {
  title       = "EC2 application load balancers should not have prohibited tags"
  description = "Check if EC2 application load balancers have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_ec2_application_load_balancer")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "ec2_classic_load_balancer_prohibited" {
  title       = "EC2 classic load balancers should not have prohibited tags"
  description = "Check if EC2 classic load balancers have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_ec2_classic_load_balancer")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "ec2_gateway_load_balancer_prohibited" {
  title       = "EC2 gateway load balancers should not have prohibited tags"
  description = "Check if EC2 gateway load balancers have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_ec2_gateway_load_balancer")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "ec2_instance_prohibited" {
  title       = "EC2 instances should not have prohibited tags"
  description = "Check if EC2 instances have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_ec2_instance")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "ec2_network_load_balancer_prohibited" {
  title       = "EC2 network load balancers should not have prohibited tags"
  description = "Check if EC2 network load balancers have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_ec2_network_load_balancer")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "ec2_reserved_instance_prohibited" {
  title       = "EC2 reserved instances should not have prohibited tags"
  description = "Check if EC2 reserved instances have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_ec2_reserved_instance")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "ecr_repository_prohibited" {
  title       = "ECR repositories should not have prohibited tags"
  description = "Check if ECR repositories have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_ecr_repository")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "ecs_container_instance_prohibited" {
  title       = "ECS container instances should not have prohibited tags"
  description = "Check if ECS container instances have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_ecs_container_instance")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "ecs_service_prohibited" {
  title       = "ECS services should not have prohibited tags"
  description = "Check if ECS services have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_ecs_service")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "efs_file_system_prohibited" {
  title       = "EFS file systems should not have prohibited tags"
  description = "Check if EFS file systems have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_efs_file_system")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "eks_addon_prohibited" {
  title       = "EKS addons should not have prohibited tags"
  description = "Check if EKS addons have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_eks_addon")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "eks_cluster_prohibited" {
  title       = "EKS clusters should not have prohibited tags"
  description = "Check if EKS clusters have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_eks_cluster")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "eks_identity_provider_config_prohibited" {
  title       = "EKS identity provider configs should not have prohibited tags"
  description = "Check if EKS identity provider configs have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_eks_identity_provider_config")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "elastic_beanstalk_application_prohibited" {
  title       = "Elastic beanstalk applications should not have prohibited tags"
  description = "Check if Elastic beanstalk applications have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_elastic_beanstalk_application")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "elastic_beanstalk_environment_prohibited" {
  title       = "Elastic beanstalk environments should not have prohibited tags"
  description = "Check if Elastic beanstalk environments have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_elastic_beanstalk_environment")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "elasticache_cluster_prohibited" {
  title       = "ElastiCache clusters should not have prohibited tags"
  description = "Check if ElastiCache clusters have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_elasticache_cluster")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "elasticsearch_domain_prohibited" {
  title       = "ElasticSearch domains should not have prohibited tags"
  description = "Check if ElasticSearch domains have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_elasticsearch_domain")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "eventbridge_rule_prohibited" {
  title       = "EventBridge rules should not have prohibited tags"
  description = "Check if EventBridge rules have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_eventbridge_rule")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "guardduty_detector_prohibited" {
  title       = "GuardDuty detectors should not have prohibited tags"
  description = "Check if GuardDuty detectors have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_guardduty_detector")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "iam_role_prohibited" {
  title       = "IAM roles should not have prohibited tags"
  description = "Check if IAM roles have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_iam_role")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "iam_server_certificate_prohibited" {
  title       = "IAM server certificates should not have prohibited tags"
  description = "Check if IAM server certificates have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_iam_server_certificate")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "iam_user_prohibited" {
  title       = "IAM users should not have prohibited tags"
  description = "Check if IAM users have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_iam_user")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "inspector_assessment_template_prohibited" {
  title       = "Inspector assessment templates should not have prohibited tags"
  description = "Check if Inspector assessment templates have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_inspector_assessment_template")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "kinesis_firehose_delivery_stream_prohibited" {
  title       = "Kinesis firehose delivery streams should not have prohibited tags"
  description = "Check if Kinesis firehose delivery streams have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_kinesis_firehose_delivery_stream")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "kms_key_prohibited" {
  title       = "KMS keys should not have prohibited tags"
  description = "Check if KMS keys have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_kms_key")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "lambda_function_prohibited" {
  title       = "Lambda functions should not have prohibited tags"
  description = "Check if Lambda functions have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_lambda_function")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "rds_db_cluster_prohibited" {
  title       = "RDS DB clusters should not have prohibited tags"
  description = "Check if RDS DB clusters have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_rds_db_cluster")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "rds_db_cluster_parameter_group_prohibited" {
  title       = "RDS DB cluster parameter groups should not have prohibited tags"
  description = "Check if RDS DB cluster parameter groups have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_rds_db_cluster_parameter_group")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "rds_db_cluster_snapshot_prohibited" {
  title       = "RDS DB cluster snapshots should not have prohibited tags"
  description = "Check if RDS DB cluster snapshots have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_rds_db_cluster_snapshot")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "rds_db_instance_prohibited" {
  title       = "RDS DB instances should not have prohibited tags"
  description = "Check if RDS DB instances have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_rds_db_instance")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "rds_db_option_group_prohibited" {
  title       = "RDS DB option groups should not have prohibited tags"
  description = "Check if RDS DB option groups have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_rds_db_option_group")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "rds_db_parameter_group_prohibited" {
  title       = "RDS DB parameter groups should not have prohibited tags"
  description = "Check if RDS DB parameter groups have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_rds_db_parameter_group")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "rds_db_snapshot_prohibited" {
  title       = "RDS DB snapshots should not have prohibited tags"
  description = "Check if RDS DB snapshots have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_rds_db_snapshot")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "rds_db_subnet_group_prohibited" {
  title       = "RDS DB subnet groups should not have prohibited tags"
  description = "Check if RDS DB subnet groups have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_rds_db_subnet_group")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "redshift_cluster_prohibited" {
  title       = "Redshift clusters should not have prohibited tags"
  description = "Check if Redshift clusters have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_redshift_cluster")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "route53_domain_prohibited" {
  title       = "Route53 domains should not have prohibited tags"
  description = "Check if Route53 domains have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_route53_domain")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "route53_resolver_endpoint_prohibited" {
  title       = "Route 53 Resolver endpoints should not have prohibited tags"
  description = "Check if Route 53 Resolver endpoints have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_route53_resolver_endpoint")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "s3_bucket_prohibited" {
  title       = "S3 buckets should not have prohibited tags"
  description = "Check if S3 buckets have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_s3_bucket")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "sagemaker_endpoint_configuration_prohibited" {
  title       = "SageMaker endpoint configurations should not have prohibited tags"
  description = "Check if SageMaker endpoint configurations have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_sagemaker_endpoint_configuration")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "sagemaker_model_prohibited" {
  title       = "SageMaker models should not have prohibited tags"
  description = "Check if SageMaker models have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_sagemaker_model")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "sagemaker_notebook_instance_prohibited" {
  title       = "SageMaker notebook instances should not have prohibited tags"
  description = "Check if SageMaker notebook instances have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_sagemaker_notebook_instance")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "sagemaker_training_job_prohibited" {
  title       = "SageMaker training jobs should not have prohibited tags"
  description = "Check if SageMaker training jobs have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_sagemaker_training_job")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "secretsmanager_secret_prohibited" {
  title       = "Secrets Manager secrets should not have prohibited tags"
  description = "Check if Secrets Manager secrets have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_secretsmanager_secret")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "ssm_parameter_prohibited" {
  title       = "SSM parameters should not have prohibited tags"
  description = "Check if SSM parameters have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_ssm_parameter")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "vpc_prohibited" {
  title       = "VPCs should not have prohibited tags"
  description = "Check if VPCs have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_vpc")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "vpc_eip_prohibited" {
  title       = "VPC elastic IP addresses should not have prohibited tags"
  description = "Check if VPC elastic IP addresses have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_vpc_eip")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "vpc_nat_gateway_prohibited" {
  title       = "VPC NAT gateways should not have prohibited tags"
  description = "Check if VPC NAT gateways have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_vpc_nat_gateway")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "vpc_network_acl_prohibited" {
  title       = "VPC network ACLs should not have prohibited tags"
  description = "Check if VPC network ACLs have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_vpc_network_acl")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "vpc_security_group_prohibited" {
  title       = "VPC security groups should not have prohibited tags"
  description = "Check if Vpc security groups have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_vpc_security_group")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "vpc_vpn_connection_prohibited" {
  title       = "Vpc VPN connections should not have prohibited tags"
  description = "Check if VPC VPN connections have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_vpc_vpn_connection")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "wafv2_ip_set_prohibited" {
  title       = "WAFV2 ip sets should not have prohibited tags"
  description = "Check if WAFV2 ip sets have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_wafv2_ip_set")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "wafv2_regex_pattern_set_prohibited" {
  title       = "WAFV2 regex pattern sets should not have prohibited tags"
  description = "Check if WAFV2 regex pattern sets have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_wafv2_regex_pattern_set")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "wafv2_rule_group_prohibited" {
  title       = "WAFV2 rule groups should not have prohibited tags"
  description = "Check if WAFV2 rule groups have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_wafv2_rule_group")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "wafv2_web_acl_prohibited" {
  title       = "WAFV2 web acls should not have prohibited tags"
  description = "Check if WAFV2 web acls have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "aws_wafv2_web_acl")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}
