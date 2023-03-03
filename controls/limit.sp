variable "tag_limit" {
  type        = number
  description = "Number of tags allowed on a resource. AWS allows up to 50 tags per resource."
  default     = 45
}

locals {
  limit_sql = <<EOT
    with analysis as (
      select
        arn,
        title,
        cardinality(array(select jsonb_object_keys(tags))) as num_tag_keys,
        region,
        account_id,
        _ctx
      from
        __TABLE_NAME__
    )
    select
      arn as resource,
      case
        when num_tag_keys > $1::integer then 'alarm'
        else 'ok'
      end as status,
      title || ' has ' || num_tag_keys || ' tag(s).' as reason
      ${local.common_dimensions_sql}
    from
      analysis
  EOT
}

benchmark "limit" {
  title       = "Limit"
  description = "The number of tags on each resource should be monitored to avoid hitting the limit unexpectedly."
  children = [
    control.accessanalyzer_analyzer_tag_limit,
    control.api_gateway_stage_tag_limit,
    control.cloudfront_distribution_tag_limit,
    control.cloudtrail_trail_tag_limit,
    control.cloudwatch_alarm_tag_limit,
    control.cloudwatch_log_group_tag_limit,
    control.codebuild_project_tag_limit,
    control.codecommit_repository_tag_limit,
    control.codepipeline_pipeline_tag_limit,
    control.config_rule_tag_limit,
    control.dax_cluster_tag_limit,
    control.directory_service_directory_tag_limit,
    control.dms_replication_instance_tag_limit,
    control.dynamodb_table_tag_limit,
    control.ebs_snapshot_tag_limit,
    control.ebs_volume_tag_limit,
    control.ec2_application_load_balancer_tag_limit,
    control.ec2_classic_load_balancer_tag_limit,
    control.ec2_gateway_load_balancer_tag_limit,
    control.ec2_instance_tag_limit,
    control.ec2_network_load_balancer_tag_limit,
    control.ec2_reserved_instance_tag_limit,
    control.ecr_repository_tag_limit,
    control.ecs_container_instance_tag_limit,
    control.ecs_service_tag_limit,
    control.efs_file_system_tag_limit,
    control.eks_addon_tag_limit,
    control.eks_cluster_tag_limit,
    control.eks_identity_provider_config_tag_limit,
    control.elastic_beanstalk_application_tag_limit,
    control.elastic_beanstalk_environment_tag_limit,
    control.elasticache_cluster_tag_limit,
    control.elasticsearch_domain_tag_limit,
    control.eventbridge_rule_tag_limit,
    control.guardduty_detector_tag_limit,
    control.iam_role_tag_limit,
    control.iam_server_certificate_tag_limit,
    control.iam_user_tag_limit,
    control.inspector_assessment_template_tag_limit,
    control.kinesis_firehose_delivery_stream_tag_limit,
    control.kms_key_tag_limit,
    control.lambda_function_tag_limit,
    control.rds_db_cluster_parameter_group_tag_limit,
    control.rds_db_cluster_snapshot_tag_limit,
    control.rds_db_cluster_tag_limit,
    control.rds_db_instance_tag_limit,
    control.rds_db_option_group_tag_limit,
    control.rds_db_parameter_group_tag_limit,
    control.rds_db_snapshot_tag_limit,
    control.rds_db_subnet_group_tag_limit,
    control.redshift_cluster_tag_limit,
    control.route53_domain_tag_limit,
    control.route53_resolver_endpoint_tag_limit,
    control.s3_bucket_tag_limit,
    control.sagemaker_endpoint_configuration_tag_limit,
    control.sagemaker_model_tag_limit,
    control.sagemaker_notebook_instance_tag_limit,
    control.sagemaker_training_job_tag_limit,
    control.secretsmanager_secret_tag_limit,
    control.ssm_parameter_tag_limit,
    control.vpc_eip_tag_limit,
    control.vpc_nat_gateway_tag_limit,
    control.vpc_network_acl_tag_limit,
    control.vpc_security_group_tag_limit,
    control.vpc_tag_limit,
    control.vpc_vpn_connection_tag_limit,
    control.wafv2_ip_set_tag_limit,
    control.wafv2_regex_pattern_set_tag_limit,
    control.wafv2_rule_group_tag_limit,
    control.wafv2_web_acl_tag_limit,
  ]

  tags = merge(local.aws_tags_common_tags, {
    type = "Benchmark"
  })
}

control "accessanalyzer_analyzer_tag_limit" {
  title       = "Access Analyzer analyzers should not exceed tag limit"
  description = "Check if the number of tags on Access Analyzer analyzers do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_accessanalyzer_analyzer")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "api_gateway_stage_tag_limit" {
  title       = "API Gateway stages should not exceed tag limit"
  description = "Check if the number of tags on API Gateway stages do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_api_gateway_stage")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "cloudfront_distribution_tag_limit" {
  title       = "CloudFront distributions should not exceed tag limit"
  description = "Check if the number of tags on CloudFront distributions do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_cloudfront_distribution")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "cloudtrail_trail_tag_limit" {
  title       = "CloudTrail trails should not exceed tag limit"
  description = "Check if the number of tags on CloudTrail trails do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_cloudtrail_trail")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "cloudwatch_alarm_tag_limit" {
  title       = "CloudWatch alarms should not exceed tag limit"
  description = "Check if the number of tags on CloudWatch alarms do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_cloudwatch_alarm")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "cloudwatch_log_group_tag_limit" {
  title       = "CloudWatch log groups should not exceed tag limit"
  description = "Check if the number of tags on Cloudwatch log groups do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_cloudwatch_log_group")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "codebuild_project_tag_limit" {
  title       = "CodeBuild projects should not exceed tag limit"
  description = "Check if the number of tags on CodeBuild projects do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_codebuild_project")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "codecommit_repository_tag_limit" {
  title       = "CodeCommit repositories should not exceed tag limit"
  description = "Check if the number of tags on CodeCommit repositories do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_codecommit_repository")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "codepipeline_pipeline_tag_limit" {
  title       = "CodePipeline pipelines should not exceed tag limit"
  description = "Check if the number of tags on CodePipeline pipelines do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_codepipeline_pipeline")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "config_rule_tag_limit" {
  title       = "Config rules should not exceed tag limit"
  description = "Check if the number of tags on Config rules do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_config_rule")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "dax_cluster_tag_limit" {
  title       = "DAX clusters should not exceed tag limit"
  description = "Check if the number of tags on DAX clusters do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_dax_cluster")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "directory_service_directory_tag_limit" {
  title       = "Directory Service directories should not exceed tag limit"
  description = "Check if the number of tags on Directory Service directories do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_directory_service_directory")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "dms_replication_instance_tag_limit" {
  title       = "DMS replication instances should not exceed tag limit"
  description = "Check if the number of tags on DMS replication instances do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_dms_replication_instance")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "dynamodb_table_tag_limit" {
  title       = "DynamoDB tables should not exceed tag limit"
  description = "Check if the number of tags on DynamoDB tables do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_dynamodb_table")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "ebs_snapshot_tag_limit" {
  title       = "EBS snapshots should not exceed tag limit"
  description = "Check if the number of tags on EBS snapshots do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_ebs_snapshot")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "ebs_volume_tag_limit" {
  title       = "EBS volumes should not exceed tag limit"
  description = "Check if the number of tags on EBS volumes do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_ebs_volume")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "ec2_application_load_balancer_tag_limit" {
  title       = "EC2 application load balancers should not exceed tag limit"
  description = "Check if the number of tags on EC2 application load balancers do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_ec2_application_load_balancer")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "ec2_classic_load_balancer_tag_limit" {
  title       = "EC2 classic load balancers should not exceed tag limit"
  description = "Check if the number of tags on EC2 classic load balancers do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_ec2_classic_load_balancer")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "ec2_gateway_load_balancer_tag_limit" {
  title       = "EC2 gateway load balancers should not exceed tag limit"
  description = "Check if the number of tags on EC2 gateway load balancers do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_ec2_gateway_load_balancer")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "ec2_instance_tag_limit" {
  title       = "EC2 instances should not exceed tag limit"
  description = "Check if the number of tags on EC2 instances do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_ec2_instance")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "ec2_network_load_balancer_tag_limit" {
  title       = "EC2 network load balancers should not exceed tag limit"
  description = "Check if the number of tags on EC2 network load balancers do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_ec2_network_load_balancer")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "ec2_reserved_instance_tag_limit" {
  title       = "EC2 reserved instances should not exceed tag limit"
  description = "Check if the number of tags on EC2 reserved instances do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_ec2_reserved_instance")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "ecr_repository_tag_limit" {
  title       = "ECR repositories should not exceed tag limit"
  description = "Check if the number of tags on ECR repositories do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_ecr_repository")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "ecs_container_instance_tag_limit" {
  title       = "ECS container instances should not exceed tag limit"
  description = "Check if the number of tags on ECS container instances do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_ecs_container_instance")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "ecs_service_tag_limit" {
  title       = "ECS services should not exceed tag limit"
  description = "Check if the number of tags on ECS services do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_ecs_service")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "efs_file_system_tag_limit" {
  title       = "EFS file systems should not exceed tag limit"
  description = "Check if the number of tags on EFS file systems do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_efs_file_system")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "eks_addon_tag_limit" {
  title       = "EKS addons should not exceed tag limit"
  description = "Check if the number of tags on EKS addons do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_eks_addon")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "eks_cluster_tag_limit" {
  title       = "EKS clusters should not exceed tag limit"
  description = "Check if the number of tags on EKS clusters do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_eks_cluster")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "eks_identity_provider_config_tag_limit" {
  title       = "EKS identity provider configs should not exceed tag limit"
  description = "Check if the number of tags on EKS identity provider configs do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_eks_identity_provider_config")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "elastic_beanstalk_application_tag_limit" {
  title       = "Elastic beanstalk applications should not exceed tag limit"
  description = "Check if the number of tags on Elastic beanstalk applications do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_elastic_beanstalk_application")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "elastic_beanstalk_environment_tag_limit" {
  title       = "Elastic beanstalk environments should not exceed tag limit"
  description = "Check if the number of tags on Elastic beanstalk environments do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_elastic_beanstalk_environment")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "elasticache_cluster_tag_limit" {
  title       = "ElastiCache clusters should not exceed tag limit"
  description = "Check if the number of tags on ElastiCache clusters do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_elasticache_cluster")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "elasticsearch_domain_tag_limit" {
  title       = "ElasticSearch domains should not exceed tag limit"
  description = "Check if the number of tags on ElasticSearch domains do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_elasticsearch_domain")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "eventbridge_rule_tag_limit" {
  title       = "EventBridge rules should not exceed tag limit"
  description = "Check if the number of tags on EventBridge rules do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_eventbridge_rule")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "guardduty_detector_tag_limit" {
  title       = "GuardDuty detectors should not exceed tag limit"
  description = "Check if the number of tags on GuardDuty detectors do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_guardduty_detector")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "iam_role_tag_limit" {
  title       = "IAM roles should not exceed tag limit"
  description = "Check if the number of tags on IAM roles do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_iam_role")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "iam_server_certificate_tag_limit" {
  title       = "IAM server certificates should not exceed tag limit"
  description = "Check if the number of tags on IAM server certificates do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_iam_server_certificate")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "iam_user_tag_limit" {
  title       = "IAM users should not exceed tag limit"
  description = "Check if the number of tags on IAM users do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_iam_user")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "inspector_assessment_template_tag_limit" {
  title       = "Inspector assessment templates should not exceed tag limit"
  description = "Check if the number of tags on Inspector assessment templates do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_inspector_assessment_template")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "kinesis_firehose_delivery_stream_tag_limit" {
  title       = "Kinesis firehose delivery streams should not exceed tag limit"
  description = "Check if the number of tags on Kinesis firehose delivery streams do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_kinesis_firehose_delivery_stream")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "kms_key_tag_limit" {
  title       = "KMS keys should not exceed tag limit"
  description = "Check if the number of tags on Kms keys do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_kms_key")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "lambda_function_tag_limit" {
  title       = "Lambda functions should not exceed tag limit"
  description = "Check if the number of tags on Lambda functions do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_lambda_function")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "rds_db_cluster_tag_limit" {
  title       = "RDS DB clusters should not exceed tag limit"
  description = "Check if the number of tags on RDS DB clusters do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_rds_db_cluster")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "rds_db_cluster_parameter_group_tag_limit" {
  title       = "RDS DB cluster parameter groups should not exceed tag limit"
  description = "Check if the number of tags on RDS DB cluster parameter groups do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_rds_db_cluster_parameter_group")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "rds_db_cluster_snapshot_tag_limit" {
  title       = "RDS DB cluster snapshots should not exceed tag limit"
  description = "Check if the number of tags on RDS DB cluster snapshots do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_rds_db_cluster_snapshot")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "rds_db_instance_tag_limit" {
  title       = "RDS DB instances should not exceed tag limit"
  description = "Check if the number of tags on RDS DB instances do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_rds_db_instance")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "rds_db_option_group_tag_limit" {
  title       = "RDS DB option groups should not exceed tag limit"
  description = "Check if the number of tags on RDS DB option groups do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_rds_db_option_group")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "rds_db_parameter_group_tag_limit" {
  title       = "RDS DB parameter groups should not exceed tag limit"
  description = "Check if the number of tags on RDS DB parameter groups do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_rds_db_parameter_group")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "rds_db_snapshot_tag_limit" {
  title       = "RDS DB snapshots should not exceed tag limit"
  description = "Check if the number of tags on RDS DB snapshots do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_rds_db_snapshot")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "rds_db_subnet_group_tag_limit" {
  title       = "RDS DB subnet groups should not exceed tag limit"
  description = "Check if the number of tags on RDS DB subnet groups do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_rds_db_subnet_group")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "redshift_cluster_tag_limit" {
  title       = "Redshift clusters should not exceed tag limit"
  description = "Check if the number of tags on Redshift clusters do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_redshift_cluster")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "route53_domain_tag_limit" {
  title       = "Route53 domains should not exceed tag limit"
  description = "Check if the number of tags on Route53 domains do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_route53_domain")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "route53_resolver_endpoint_tag_limit" {
  title       = "Route 53 Resolver endpoints should not exceed tag limit"
  description = "Check if the number of tags on Route 53 Resolver endpoints do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_route53_resolver_endpoint")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "s3_bucket_tag_limit" {
  title       = "S3 buckets should not exceed tag limit"
  description = "Check if the number of tags on S3 buckets do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_s3_bucket")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "sagemaker_endpoint_configuration_tag_limit" {
  title       = "SageMaker endpoint configurations should not exceed tag limit"
  description = "Check if the number of tags on SageMaker endpoint configurations do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_sagemaker_endpoint_configuration")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "sagemaker_model_tag_limit" {
  title       = "SageMaker models should not exceed tag limit"
  description = "Check if the number of tags on SageMaker models do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_sagemaker_model")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "sagemaker_notebook_instance_tag_limit" {
  title       = "SageMaker notebook instances should not exceed tag limit"
  description = "Check if the number of tags on SageMaker notebook instances do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_sagemaker_notebook_instance")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "sagemaker_training_job_tag_limit" {
  title       = "SageMaker training jobs should not exceed tag limit"
  description = "Check if the number of tags on SageMaker training jobs do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_sagemaker_training_job")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "secretsmanager_secret_tag_limit" {
  title       = "Secrets Manager secrets should not exceed tag limit"
  description = "Check if the number of tags on Secrets Manager secrets do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_secretsmanager_secret")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "ssm_parameter_tag_limit" {
  title       = "SSM parameters should not exceed tag limit"
  description = "Check if the number of tags on Ssm parameters do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_ssm_parameter")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "vpc_tag_limit" {
  title       = "VPCs should not exceed tag limit"
  description = "Check if the number of tags on Vpcs do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_vpc")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "vpc_eip_tag_limit" {
  title       = "VPC elastic IP addresses should not exceed tag limit"
  description = "Check if the number of tags on VPC elastic IP addresses do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_vpc_eip")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "vpc_nat_gateway_tag_limit" {
  title       = "VPC NAT gateways should not exceed tag limit"
  description = "Check if the number of tags on VPC NAT gateways do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_vpc_nat_gateway")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "vpc_network_acl_tag_limit" {
  title       = "VPC network ACLs should not exceed tag limit"
  description = "Check if the number of tags on VPC network ACLs do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_vpc_network_acl")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "vpc_security_group_tag_limit" {
  title       = "VPC security groups should not exceed tag limit"
  description = "Check if the number of tags on VPC security groups do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_vpc_security_group")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "vpc_vpn_connection_tag_limit" {
  title       = "VPC VPN connections should not exceed tag limit"
  description = "Check if the number of tags on VPC VPN connections do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_vpc_vpn_connection")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "wafv2_ip_set_tag_limit" {
  title       = "WAFV2 ip sets should not exceed tag limit"
  description = "Check if the number of tags on WAFV2 ip sets do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_wafv2_ip_set")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "wafv2_regex_pattern_set_tag_limit" {
  title       = "WAFV2 regex pattern sets should not exceed tag limit"
  description = "Check if the number of tags on WAFV2 regex pattern sets do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_wafv2_regex_pattern_set")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "wafv2_rule_group_tag_limit" {
  title       = "WAFV2 rule groups should not exceed tag limit"
  description = "Check if the number of tags on WAFV2 rule groups do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_wafv2_rule_group")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "wafv2_web_acl_tag_limit" {
  title       = "WAFV2 web acls should not exceed tag limit"
  description = "Check if the number of tags on WAFV2 web acls do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "aws_wafv2_web_acl")
  param "tag_limit" {
    default = var.tag_limit
  }
}
