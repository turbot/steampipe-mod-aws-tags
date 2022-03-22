variable "mandatory_tags" {
  type        = list(string)
  description = "A list of mandatory tags to check for."
  default     = ["Environment", "Owner"]
}

locals {
  mandatory_sql = <<EOT
    with analysis as (
      select
        arn,
        title,
        tags ?& $1 as has_mandatory_tags,
        to_jsonb($1) - array(select jsonb_object_keys(tags)) as missing_tags,
        __DIMENSIONS__
      from
        __TABLE_NAME__
    )
    select
      arn as resource,
      case
        when has_mandatory_tags then 'ok'
        else 'alarm'
      end as status,
      case
        when has_mandatory_tags then title || ' has all mandatory tags.'
        else title || ' is missing tags: ' || array_to_string(array(select jsonb_array_elements_text(missing_tags)), ', ') || '.'
      end as reason,
      __DIMENSIONS__
    from
      analysis
  EOT
}

locals {
  mandatory_sql_account = replace(local.mandatory_sql, "__DIMENSIONS__", "account_id")
  mandatory_sql_region  = replace(local.mandatory_sql, "__DIMENSIONS__", "region, account_id")
}

benchmark "mandatory" {
  title       = "Mandatory"
  description = "Resources should all have a standard set of tags applied for functions like resource organization, automation, cost control, and access control."
  children = [
    control.accessanalyzer_analyzer_mandatory,
    control.api_gateway_stage_mandatory,
    control.cloudfront_distribution_mandatory,
    control.cloudtrail_trail_mandatory,
    control.cloudwatch_alarm_mandatory,
    control.cloudwatch_log_group_mandatory,
    control.codebuild_project_mandatory,
    control.codecommit_repository_mandatory,
    control.codepipeline_pipeline_mandatory,
    control.config_rule_mandatory,
    control.dax_cluster_mandatory,
    control.directory_service_directory_mandatory,
    control.dms_replication_instance_mandatory,
    control.dynamodb_table_mandatory,
    control.ebs_snapshot_mandatory,
    control.ebs_volume_mandatory,
    control.ec2_application_load_balancer_mandatory,
    control.ec2_classic_load_balancer_mandatory,
    control.ec2_gateway_load_balancer_mandatory,
    control.ec2_instance_mandatory,
    control.ec2_network_load_balancer_mandatory,
    control.ec2_reserved_instance_mandatory,
    control.ecr_repository_mandatory,
    control.ecs_container_instance_mandatory,
    control.ecs_service_mandatory,
    control.efs_file_system_mandatory,
    control.eks_addon_mandatory,
    control.eks_cluster_mandatory,
    control.eks_identity_provider_config_mandatory,
    control.elastic_beanstalk_application_mandatory,
    control.elastic_beanstalk_environment_mandatory,
    control.elasticache_cluster_mandatory,
    control.elasticsearch_domain_mandatory,
    control.eventbridge_rule_mandatory,
    control.guardduty_detector_mandatory,
    control.iam_role_mandatory,
    control.iam_server_certificate_mandatory,
    control.iam_user_mandatory,
    control.inspector_assessment_template_mandatory,
    control.kinesis_firehose_delivery_stream_mandatory,
    control.kms_key_mandatory,
    control.lambda_function_mandatory,
    control.rds_db_cluster_mandatory,
    control.rds_db_cluster_parameter_group_mandatory,
    control.rds_db_cluster_snapshot_mandatory,
    control.rds_db_instance_mandatory,
    control.rds_db_option_group_mandatory,
    control.rds_db_parameter_group_mandatory,
    control.rds_db_snapshot_mandatory,
    control.rds_db_subnet_group_mandatory,
    control.redshift_cluster_mandatory,
    control.route53_domain_mandatory,
    control.route53_resolver_endpoint_mandatory,
    control.s3_bucket_mandatory,
    control.sagemaker_endpoint_configuration_mandatory,
    control.sagemaker_model_mandatory,
    control.sagemaker_notebook_instance_mandatory,
    control.sagemaker_training_job_mandatory,
    control.secretsmanager_secret_mandatory,
    control.ssm_parameter_mandatory,
    control.tagging_resource_mandatory,
    control.vpc_mandatory,
    control.vpc_eip_mandatory,
    control.vpc_nat_gateway_mandatory,
    control.vpc_network_acl_mandatory,
    control.vpc_security_group_mandatory,
    control.vpc_vpn_connection_mandatory,
    control.wafv2_ip_set_mandatory,
    control.wafv2_regex_pattern_set_mandatory,
    control.wafv2_rule_group_mandatory,
    control.wafv2_web_acl_mandatory
  ]
}

control "accessanalyzer_analyzer_mandatory" {
  title       = "Access Analyzer analyzers should have mandatory tags"
  description = "Check if Access Analyzer analyzers have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_accessanalyzer_analyzer")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "api_gateway_stage_mandatory" {
  title       = "API Gateway stages should have mandatory tags"
  description = "Check if API Gateway stages have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_api_gateway_stage")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "cloudfront_distribution_mandatory" {
  title       = "CloudFront distributions should have mandatory tags"
  description = "Check if CloudFront distributions have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_cloudfront_distribution")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "cloudtrail_trail_mandatory" {
  title       = "CloudTrail trails should have mandatory tags"
  description = "Check if CloudTrail trails have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_cloudtrail_trail")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "cloudwatch_alarm_mandatory" {
  title       = "CloudWatch alarms should have mandatory tags"
  description = "Check if CloudWatch alarms have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_cloudwatch_alarm")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "cloudwatch_log_group_mandatory" {
  title       = "CloudWatch log groups should have mandatory tags"
  description = "Check if CloudWatch log groups have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_cloudwatch_log_group")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "codebuild_project_mandatory" {
  title       = "CodeBuild projects should have mandatory tags"
  description = "Check if CodeBuild projects have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_codebuild_project")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "codecommit_repository_mandatory" {
  title       = "CodeCommit repositories should have mandatory tags"
  description = "Check if CodeCommit repositories have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_codecommit_repository")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "codepipeline_pipeline_mandatory" {
  title       = "CodePipeline pipelines should have mandatory tags"
  description = "Check if CodePipeline pipelines have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_codepipeline_pipeline")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "config_rule_mandatory" {
  title       = "Config rules should have mandatory tags"
  description = "Check if Config rules have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_config_rule")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "dax_cluster_mandatory" {
  title       = "DAX clusters should have mandatory tags"
  description = "Check if DAX clusters have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_dax_cluster")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "directory_service_directory_mandatory" {
  title       = "Directory Service directories should have mandatory tags"
  description = "Check if Directory Service directories have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_directory_service_directory")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "dms_replication_instance_mandatory" {
  title       = "DMS replication instances should have mandatory tags"
  description = "Check if Dms replication instances have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_dms_replication_instance")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "dynamodb_table_mandatory" {
  title       = "DynamoDB tables should have mandatory tags"
  description = "Check if DynamoDB tables have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_dynamodb_table")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "ebs_snapshot_mandatory" {
  title       = "EBS snapshots should have mandatory tags"
  description = "Check if EBS snapshots have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_ebs_snapshot")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "ebs_volume_mandatory" {
  title       = "EBS volumes should have mandatory tags"
  description = "Check if EBS volumes have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_ebs_volume")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "ec2_application_load_balancer_mandatory" {
  title       = "EC2 application load balancers should have mandatory tags"
  description = "Check if EC2 application load balancers have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_ec2_application_load_balancer")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "ec2_classic_load_balancer_mandatory" {
  title       = "EC2 classic load balancers should have mandatory tags"
  description = "Check if EC2 classic load balancers have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_ec2_classic_load_balancer")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "ec2_gateway_load_balancer_mandatory" {
  title       = "EC2 gateway load balancers should have mandatory tags"
  description = "Check if EC2 gateway load balancers have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_ec2_gateway_load_balancer")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "ec2_instance_mandatory" {
  title       = "EC2 instances should have mandatory tags"
  description = "Check if EC2 instances have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_ec2_instance")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "ec2_network_load_balancer_mandatory" {
  title       = "EC2 network load balancers should have mandatory tags"
  description = "Check if EC2 network load balancers have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_ec2_network_load_balancer")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "ec2_reserved_instance_mandatory" {
  title       = "EC2 reserved instances should have mandatory tags"
  description = "Check if EC2 reserved instances have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_ec2_reserved_instance")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "ecr_repository_mandatory" {
  title       = "ECR repositories should have mandatory tags"
  description = "Check if ECR repositories have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_ecr_repository")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "ecs_container_instance_mandatory" {
  title       = "ECS container instances should have mandatory tags"
  description = "Check if ECS container instances have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_ecs_container_instance")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "ecs_service_mandatory" {
  title       = "ECS services should have mandatory tags"
  description = "Check if ECS services have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_ecs_service")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "efs_file_system_mandatory" {
  title       = "EFS file systems should have mandatory tags"
  description = "Check if EFS file systems have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_efs_file_system")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "eks_addon_mandatory" {
  title       = "EKS addons should have mandatory tags"
  description = "Check if EKS addons have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_eks_addon")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "eks_cluster_mandatory" {
  title       = "EKS clusters should have mandatory tags"
  description = "Check if EKS clusters have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_eks_cluster")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "eks_identity_provider_config_mandatory" {
  title       = "EKS identity provider configs should have mandatory tags"
  description = "Check if EKS identity provider configs have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_eks_identity_provider_config")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "elastic_beanstalk_application_mandatory" {
  title       = "Elastic beanstalk applications should have mandatory tags"
  description = "Check if Elastic beanstalk applications have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_elastic_beanstalk_application")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "elastic_beanstalk_environment_mandatory" {
  title       = "Elastic beanstalk environments should have mandatory tags"
  description = "Check if Elastic beanstalk environments have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_elastic_beanstalk_environment")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "elasticache_cluster_mandatory" {
  title       = "ElastiCache clusters should have mandatory tags"
  description = "Check if ElastiCache clusters have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_elasticache_cluster")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "elasticsearch_domain_mandatory" {
  title       = "ElasticSearch domains should have mandatory tags"
  description = "Check if ElasticSearch domains have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_elasticsearch_domain")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "eventbridge_rule_mandatory" {
  title       = "EventBridge rules should have mandatory tags"
  description = "Check if EventBridge rules have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_eventbridge_rule")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "guardduty_detector_mandatory" {
  title       = "GuardDuty detectors should have mandatory tags"
  description = "Check if GuardDuty detectors have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_guardduty_detector")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "iam_role_mandatory" {
  title       = "IAM roles should have mandatory tags"
  description = "Check if IAM roles have mandatory tags."
  sql         = replace(local.mandatory_sql_account, "__TABLE_NAME__", "aws_iam_role")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "iam_server_certificate_mandatory" {
  title       = "IAM server certificates should have mandatory tags"
  description = "Check if IAM server certificates have mandatory tags."
  sql         = replace(local.mandatory_sql_account, "__TABLE_NAME__", "aws_iam_server_certificate")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "iam_user_mandatory" {
  title       = "IAM users should have mandatory tags"
  description = "Check if IAM users have mandatory tags."
  sql         = replace(local.mandatory_sql_account, "__TABLE_NAME__", "aws_iam_user")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "inspector_assessment_template_mandatory" {
  title       = "Inspector assessment templates should have mandatory tags"
  description = "Check if Inspector assessment templates have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_inspector_assessment_template")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "kinesis_firehose_delivery_stream_mandatory" {
  title       = "Kinesis firehose delivery streams should have mandatory tags"
  description = "Check if Kinesis firehose delivery streams have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_kinesis_firehose_delivery_stream")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "kms_key_mandatory" {
  title       = "KMS keys should have mandatory tags"
  description = "Check if KMS keys have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_kms_key")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "lambda_function_mandatory" {
  title       = "Lambda functions should have mandatory tags"
  description = "Check if Lambda functions have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_lambda_function")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "rds_db_cluster_mandatory" {
  title       = "RDS DB clusters should have mandatory tags"
  description = "Check if RDS DB clusters have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_rds_db_cluster")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "rds_db_cluster_parameter_group_mandatory" {
  title       = "RDS DB cluster parameter groups should have mandatory tags"
  description = "Check if RDS DB cluster parameter groups have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_rds_db_cluster_parameter_group")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "rds_db_cluster_snapshot_mandatory" {
  title       = "RDS DB cluster snapshots should have mandatory tags"
  description = "Check if RDS DB cluster snapshots have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_rds_db_cluster_snapshot")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "rds_db_instance_mandatory" {
  title       = "RDS DB instances should have mandatory tags"
  description = "Check if RDS DB instances have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_rds_db_instance")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "rds_db_option_group_mandatory" {
  title       = "RDS DB option groups should have mandatory tags"
  description = "Check if RDS DB option groups have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_rds_db_option_group")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "rds_db_parameter_group_mandatory" {
  title       = "RDS DB parameter groups should have mandatory tags"
  description = "Check if RDS DB parameter groups have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_rds_db_parameter_group")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "rds_db_snapshot_mandatory" {
  title       = "RDS DB snapshots should have mandatory tags"
  description = "Check if RDS DB snapshots have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_rds_db_snapshot")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "rds_db_subnet_group_mandatory" {
  title       = "RDS DB subnet groups should have mandatory tags"
  description = "Check if RDS DB subnet groups have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_rds_db_subnet_group")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "redshift_cluster_mandatory" {
  title       = "Redshift clusters should have mandatory tags"
  description = "Check if Redshift clusters have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_redshift_cluster")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "route53_domain_mandatory" {
  title       = "Route53 domains should have mandatory tags"
  description = "Check if Route53 domains have mandatory tags."
  sql         = replace(local.mandatory_sql_account, "__TABLE_NAME__", "aws_route53_domain")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "route53_resolver_endpoint_mandatory" {
  title       = "Route 53 Resolver endpoints should have mandatory tags"
  description = "Check if Route 53 Resolver endpoints have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_route53_resolver_endpoint")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "s3_bucket_mandatory" {
  title       = "S3 buckets should have mandatory tags"
  description = "Check if S3 buckets have mandatory tags."
  sql         = replace(local.mandatory_sql_account, "__TABLE_NAME__", "aws_s3_bucket")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "sagemaker_endpoint_configuration_mandatory" {
  title       = "SageMaker endpoint configurations should have mandatory tags"
  description = "Check if SageMaker endpoint configurations have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_sagemaker_endpoint_configuration")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "sagemaker_model_mandatory" {
  title       = "SageMaker models should have mandatory tags"
  description = "Check if SageMaker models have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_sagemaker_model")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "sagemaker_notebook_instance_mandatory" {
  title       = "SageMaker notebook instances should have mandatory tags"
  description = "Check if SageMaker notebook instances have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_sagemaker_notebook_instance")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "sagemaker_training_job_mandatory" {
  title       = "SageMaker training jobs should have mandatory tags"
  description = "Check if SageMaker training jobs have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_sagemaker_training_job")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "secretsmanager_secret_mandatory" {
  title       = "Secrets Manager secrets should have mandatory tags"
  description = "Check if Secrets Manager secrets have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_secretsmanager_secret")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "ssm_parameter_mandatory" {
  title       = "SSM parameters should have mandatory tags"
  description = "Check if SSM parameters have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_ssm_parameter")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "tagging_resource_mandatory" {
  title       = "Tagging resources should have mandatory tags"
  description = "Check if Tagging resources have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_tagging_resource")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "vpc_mandatory" {
  title       = "VPCs should have mandatory tags"
  description = "Check if VPCs have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_vpc")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "vpc_eip_mandatory" {
  title       = "VPC elastic IP addresses should have mandatory tags"
  description = "Check if VPC elastic IP addresses have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_vpc_eip")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "vpc_nat_gateway_mandatory" {
  title       = "VPC NAT gateways should have mandatory tags"
  description = "Check if VPC NAT gateways have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_vpc_nat_gateway")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "vpc_network_acl_mandatory" {
  title       = "VPC network ACLs should have mandatory tags"
  description = "Check if VPC network ACLs have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_vpc_network_acl")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "vpc_security_group_mandatory" {
  title       = "VPC security groups should have mandatory tags"
  description = "Check if VPC security groups have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_vpc_security_group")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "vpc_vpn_connection_mandatory" {
  title       = "VPC VPN connections should have mandatory tags"
  description = "Check if VPC VPN connections have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_vpc_vpn_connection")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "wafv2_ip_set_mandatory" {
  title       = "WAFV2 ip sets should have mandatory tags"
  description = "Check if WAFV2 ip sets have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_wafv2_ip_set")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "wafv2_regex_pattern_set_mandatory" {
  title       = "WAFV2 regex pattern sets should have mandatory tags"
  description = "Check if WAFV2 regex pattern sets have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_wafv2_regex_pattern_set")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "wafv2_rule_group_mandatory" {
  title       = "WAFV2 rule groups should have mandatory tags"
  description = "Check if WAFV2 rule groups have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_wafv2_rule_group")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "wafv2_web_acl_mandatory" {
  title       = "WAFV2 web acls should have mandatory tags"
  description = "Check if WAFV2 web acls have mandatory tags."
  sql         = replace(local.mandatory_sql_region, "__TABLE_NAME__", "aws_wafv2_web_acl")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}
