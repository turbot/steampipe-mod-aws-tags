locals {
  untagged_sql = <<EOT
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
      __DIMENSIONS__
    from
      __TABLE_NAME__
  EOT
}

locals {
  untagged_sql_account = replace(local.untagged_sql, "__DIMENSIONS__", "account_id")
  untagged_sql_region  = replace(local.untagged_sql, "__DIMENSIONS__", "region, account_id")
}

benchmark "untagged" {
  title       = "Untagged"
  description = "Untagged resources are difficult to monitor and should be identified and remediated."
  children = [
    control.accessanalyzer_analyzer_untagged,
    control.api_gateway_stage_untagged,
    control.auditmanager_assessment_untagged,
    control.auditmanager_control_untagged,
    control.auditmanager_framework_untagged,
    control.cloudfront_distribution_untagged,
    control.cloudtrail_trail_untagged,
    control.cloudwatch_alarm_untagged,
    control.cloudwatch_log_group_untagged,
    control.codebuild_project_untagged,
    control.codecommit_repository_untagged,
    control.codepipeline_pipeline_untagged,
    control.config_rule_untagged,
    control.dax_cluster_untagged,
    control.directory_service_directory_untagged,
    control.dms_replication_instance_untagged,
    control.dynamodb_table_untagged,
    control.ebs_snapshot_untagged,
    control.ebs_volume_untagged,
    control.ec2_application_load_balancer_untagged,
    control.ec2_classic_load_balancer_untagged,
    control.ec2_gateway_load_balancer_untagged,
    control.ec2_instance_untagged,
    control.ec2_network_load_balancer_untagged,
    control.ec2_reserved_instance_untagged,
    control.ecr_repository_untagged,
    control.ecrpublic_repository_untagged,
    control.ecs_container_instance_untagged,
    control.ecs_service_untagged,
    control.efs_file_system_untagged,
    control.eks_addon_untagged,
    control.eks_cluster_untagged,
    control.eks_identity_provider_config_untagged,
    control.elastic_beanstalk_application_untagged,
    control.elastic_beanstalk_environment_untagged,
    control.elasticache_cluster_untagged,
    control.elasticsearch_domain_untagged,
    control.eventbridge_rule_untagged,
    control.guardduty_detector_untagged,
    control.iam_policy_untagged,
    control.iam_role_untagged,
    control.iam_server_certificate_untagged,
    control.iam_user_untagged,
    control.inspector_assessment_template_untagged,
    control.kinesis_firehose_delivery_stream_untagged,
    control.kms_key_untagged,
    control.lambda_function_untagged,
    control.macie2_classification_job_untagged,
    control.rds_db_cluster_untagged,
    control.rds_db_cluster_parameter_group_untagged,
    control.rds_db_cluster_snapshot_untagged,
    control.rds_db_instance_untagged,
    control.rds_db_option_group_untagged,
    control.rds_db_parameter_group_untagged,
    control.rds_db_snapshot_untagged,
    control.rds_db_subnet_group_untagged,
    control.redshift_cluster_untagged,
    control.route53_domain_untagged,
    control.route53_resolver_endpoint_untagged,
    control.route53_resolver_rule_untagged,
    control.s3_bucket_untagged,
    control.sagemaker_endpoint_configuration_untagged,
    control.sagemaker_model_untagged,
    control.sagemaker_notebook_instance_untagged,
    control.sagemaker_training_job_untagged,
    control.secretsmanager_secret_untagged,
    control.ssm_parameter_untagged,
    control.tagging_resource_untagged,
    control.vpc_untagged,
    control.vpc_eip_untagged,
    control.vpc_nat_gateway_untagged,
    control.vpc_network_acl_untagged,
    control.vpc_security_group_untagged,
    control.vpc_vpn_connection_untagged,
    control.wafv2_ip_set_untagged,
    control.wafv2_regex_pattern_set_untagged,
    control.wafv2_rule_group_untagged,
    control.wafv2_web_acl_untagged
  ]
}

control "accessanalyzer_analyzer_untagged" {
  title       = "Access Analyzer analyzers should be tagged"
  description = "Check if Access Analyzer analyzers have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_accessanalyzer_analyzer")
}

control "api_gateway_stage_untagged" {
  title       = "API gateway stages should be tagged"
  description = "Check if API gateway stages have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_api_gateway_stage")
}

control "auditmanager_assessment_untagged" {
  title       = "Audit Manager assessments should be tagged"
  description = "Check if Audit Manager assessments have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_auditmanager_assessment")
}

control "auditmanager_control_untagged" {
  title       = "Audit Manager controls should be tagged"
  description = "Check if Audit Manager controls have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_auditmanager_control")
}

control "auditmanager_framework_untagged" {
  title       = "Audit Manager frameworks should be tagged"
  description = "Check if Audit Manager frameworks have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_auditmanager_framework")
}

control "cloudfront_distribution_untagged" {
  title       = "CloudFront distributions should be tagged"
  description = "Check if CloudFront distributions have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_cloudfront_distribution")
}

control "cloudtrail_trail_untagged" {
  title       = "CloudTrail trails should be tagged"
  description = "Check if CloudTrail trails have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_cloudtrail_trail")
}

control "cloudwatch_alarm_untagged" {
  title       = "CloudWatch alarms should be tagged"
  description = "Check if CloudWatch alarms have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_cloudwatch_alarm")
}

control "cloudwatch_log_group_untagged" {
  title       = "CloudWatch log groups should be tagged"
  description = "Check if CloudWatch log groups have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_cloudwatch_log_group")
}

control "codebuild_project_untagged" {
  title       = "CodeBuild projects should be tagged"
  description = "Check if CodeBuild projects have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_codebuild_project")
}

control "codecommit_repository_untagged" {
  title       = "CodeCommit repositories should be tagged"
  description = "Check if CodeCommit repositories have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_codecommit_repository")
}

control "codepipeline_pipeline_untagged" {
  title       = "CodePipeline pipelines should be tagged"
  description = "Check if CodePipeline pipelines have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_codepipeline_pipeline")
}

control "config_rule_untagged" {
  title       = "Config rules should be tagged"
  description = "Check if Config rules have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_config_rule")
}

control "dax_cluster_untagged" {
  title       = "DAX clusters should be tagged"
  description = "Check if DAX clusters have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_dax_cluster")
}

control "directory_service_directory_untagged" {
  title       = "Directory service directories should be tagged"
  description = "Check if Directory service directories have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_directory_service_directory")
}

control "dms_replication_instance_untagged" {
  title       = "Dms replication instances should be tagged"
  description = "Check if Dms replication instances have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_dms_replication_instance")
}

control "dynamodb_table_untagged" {
  title       = "DynamoDB tables should be tagged"
  description = "Check if DynamoDB tables have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_dynamodb_table")
}

control "ebs_snapshot_untagged" {
  title       = "EBS snapshots should be tagged"
  description = "Check if EBS snapshots have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_ebs_snapshot")
}

control "ebs_volume_untagged" {
  title       = "EBS volumes should be tagged"
  description = "Check if EBS volumes have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_ebs_volume")
}

control "ec2_application_load_balancer_untagged" {
  title       = "EC2 application load balancers should be tagged"
  description = "Check if EC2 application load balancers have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_ec2_application_load_balancer")
}

control "ec2_classic_load_balancer_untagged" {
  title       = "EC2 classic load balancers should be tagged"
  description = "Check if EC2 classic load balancers have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_ec2_classic_load_balancer")
}

control "ec2_gateway_load_balancer_untagged" {
  title       = "EC2 gateway load balancers should be tagged"
  description = "Check if EC2 gateway load balancers have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_ec2_gateway_load_balancer")
}

control "ec2_instance_untagged" {
  title       = "EC2 instances should be tagged"
  description = "Check if EC2 instances have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_ec2_instance")
}

control "ec2_network_load_balancer_untagged" {
  title       = "EC2 network load balancers should be tagged"
  description = "Check if EC2 network load balancers have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_ec2_network_load_balancer")
}

control "ec2_reserved_instance_untagged" {
  title       = "EC2 reserved instances should be tagged"
  description = "Check if EC2 reserved instances have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_ec2_reserved_instance")
}

control "ecr_repository_untagged" {
  title       = "ECR repositories should be tagged"
  description = "Check if ECR repositories have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_ecr_repository")
}

control "ecrpublic_repository_untagged" {
  title       = "ECR public repositories should be tagged"
  description = "Check if ECR public repositories have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_ecrpublic_repository")
}

control "ecs_container_instance_untagged" {
  title       = "ECS container instances should be tagged"
  description = "Check if ECS container instances have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_ecs_container_instance")
}

control "ecs_service_untagged" {
  title       = "ECS services should be tagged"
  description = "Check if ECS services have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_ecs_service")
}

control "efs_file_system_untagged" {
  title       = "EFS file systems should be tagged"
  description = "Check if EFS file systems have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_efs_file_system")
}

control "eks_addon_untagged" {
  title       = "EKS addons should be tagged"
  description = "Check if EKS addons have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_eks_addon")
}

control "eks_cluster_untagged" {
  title       = "EKS clusters should be tagged"
  description = "Check if EKS clusters have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_eks_cluster")
}

control "eks_identity_provider_config_untagged" {
  title       = "EKS identity provider configs should be tagged"
  description = "Check if EKS identity provider configs have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_eks_identity_provider_config")
}

control "elastic_beanstalk_application_untagged" {
  title       = "Elastic beanstalk applications should be tagged"
  description = "Check if Elastic beanstalk applications have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_elastic_beanstalk_application")
}

control "elastic_beanstalk_environment_untagged" {
  title       = "Elastic beanstalk environments should be tagged"
  description = "Check if Elastic beanstalk environments have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_elastic_beanstalk_environment")
}

control "elasticache_cluster_untagged" {
  title       = "ElastiCache clusters should be tagged"
  description = "Check if ElastiCache clusters have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_elasticache_cluster")
}

control "elasticsearch_domain_untagged" {
  title       = "ElasticSearch domains should be tagged"
  description = "Check if ElasticSearch domains have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_elasticsearch_domain")
}

control "eventbridge_rule_untagged" {
  title       = "EventBridge rules should be tagged"
  description = "Check if EventBridge rules have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_eventbridge_rule")
}

control "guardduty_detector_untagged" {
  title       = "GuardDuty detectors should be tagged"
  description = "Check if GuardDuty detectors have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_guardduty_detector")
}

control "iam_policy_untagged" {
  title       = "IAM policies should be tagged"
  description = "Check if IAM policies have at least 1 tag."
  sql         = replace(local.untagged_sql_account, "__TABLE_NAME__", "aws_iam_policy")
}

control "iam_role_untagged" {
  title       = "IAM roles should be tagged"
  description = "Check if IAM roles have at least 1 tag."
  sql         = replace(local.untagged_sql_account, "__TABLE_NAME__", "aws_iam_role")
}

control "iam_server_certificate_untagged" {
  title       = "IAM server certificates should be tagged"
  description = "Check if IAM server certificates have at least 1 tag."
  sql         = replace(local.untagged_sql_account, "__TABLE_NAME__", "aws_iam_server_certificate")
}

control "iam_user_untagged" {
  title       = "IAM users should be tagged"
  description = "Check if IAM users have at least 1 tag."
  sql         = replace(local.untagged_sql_account, "__TABLE_NAME__", "aws_iam_user")
}

control "inspector_assessment_template_untagged" {
  title       = "Inspector assessment templates should be tagged"
  description = "Check if Inspector assessment templates have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_inspector_assessment_template")
}

control "kinesis_firehose_delivery_stream_untagged" {
  title       = "Kinesis firehose delivery streams should be tagged"
  description = "Check if Kinesis firehose delivery streams have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_kinesis_firehose_delivery_stream")
}

control "kms_key_untagged" {
  title       = "KMS keys should be tagged"
  description = "Check if KMS keys have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_kms_key")
}

control "lambda_function_untagged" {
  title       = "Lambda functions should be tagged"
  description = "Check if Lambda functions have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_lambda_function")
}

control "macie2_classification_job_untagged" {
  title       = "Macie2 classification jobs should be tagged"
  description = "Check if Macie2 classification jobs have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_macie2_classification_job")
}

control "rds_db_cluster_untagged" {
  title       = "RDS db clusters should be tagged"
  description = "Check if RDS db clusters have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_rds_db_cluster")
}

control "rds_db_cluster_parameter_group_untagged" {
  title       = "RDS db cluster parameter groups should be tagged"
  description = "Check if RDS db cluster parameter groups have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_rds_db_cluster_parameter_group")
}

control "rds_db_cluster_snapshot_untagged" {
  title       = "RDS db cluster snapshots should be tagged"
  description = "Check if RDS db cluster snapshots have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_rds_db_cluster_snapshot")
}

control "rds_db_instance_untagged" {
  title       = "RDS db instances should be tagged"
  description = "Check if RDS db instances have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_rds_db_instance")
}

control "rds_db_option_group_untagged" {
  title       = "RDS db option groups should be tagged"
  description = "Check if RDS db option groups have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_rds_db_option_group")
}

control "rds_db_parameter_group_untagged" {
  title       = "RDS db parameter groups should be tagged"
  description = "Check if RDS db parameter groups have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_rds_db_parameter_group")
}

control "rds_db_snapshot_untagged" {
  title       = "RDS db snapshots should be tagged"
  description = "Check if RDS db snapshots have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_rds_db_snapshot")
}

control "rds_db_subnet_group_untagged" {
  title       = "RDS db subnet groups should be tagged"
  description = "Check if RDS db subnet groups have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_rds_db_subnet_group")
}

control "redshift_cluster_untagged" {
  title       = "Redshift clusters should be tagged"
  description = "Check if Redshift clusters have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_redshift_cluster")
}

control "route53_domain_untagged" {
  title       = "Route53 domains should be tagged"
  description = "Check if Route53 domains have at least 1 tag."
  sql         = replace(local.untagged_sql_account, "__TABLE_NAME__", "aws_route53_domain")
}

control "route53_resolver_endpoint_untagged" {
  title       = "Route53 resolver endpoints should be tagged"
  description = "Check if Route53 resolver endpoints have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_route53_resolver_endpoint")
}

control "route53_resolver_rule_untagged" {
  title       = "Route53 resolver rules should be tagged"
  description = "Check if Route53 resolver rules have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_route53_resolver_rule")
}

control "s3_bucket_untagged" {
  title       = "S3 buckets should be tagged"
  description = "Check if S3 buckets have at least 1 tag."
  sql         = replace(local.untagged_sql_account, "__TABLE_NAME__", "aws_s3_bucket")
}

control "sagemaker_endpoint_configuration_untagged" {
  title       = "SageMaker endpoint configurations should be tagged"
  description = "Check if SageMaker endpoint configurations have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_sagemaker_endpoint_configuration")
}

control "sagemaker_model_untagged" {
  title       = "SageMaker models should be tagged"
  description = "Check if SageMaker models have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_sagemaker_model")
}

control "sagemaker_notebook_instance_untagged" {
  title       = "SageMaker notebook instances should be tagged"
  description = "Check if SageMaker notebook instances have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_sagemaker_notebook_instance")
}

control "sagemaker_training_job_untagged" {
  title       = "SageMaker training jobs should be tagged"
  description = "Check if SageMaker training jobs have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_sagemaker_training_job")
}

control "secretsmanager_secret_untagged" {
  title       = "Secrets Manager secrets should be tagged"
  description = "Check if Secrets Manager secrets have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_secretsmanager_secret")
}

control "ssm_parameter_untagged" {
  title       = "SSM parameters should be tagged"
  description = "Check if SSM parameters have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_ssm_parameter")
}

control "tagging_resource_untagged" {
  title       = "Tagging resources should be tagged"
  description = "Check if Tagging resources have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_tagging_resource")
}

control "vpc_untagged" {
  title       = "VPCs should be tagged"
  description = "Check if VPCs have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_vpc")
}

control "vpc_eip_untagged" {
  title       = "VPC elastic IP addresses should be tagged"
  description = "Check if VPC elastic IP addresses have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_vpc_eip")
}

control "vpc_nat_gateway_untagged" {
  title       = "VPC NAT gateways should be tagged"
  description = "Check if VPC NAT gateways have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_vpc_nat_gateway")
}

control "vpc_network_acl_untagged" {
  title       = "VPC network ACLs should be tagged"
  description = "Check if VPC network ACLs have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_vpc_network_acl")
}

control "vpc_security_group_untagged" {
  title       = "VPC security groups should be tagged"
  description = "Check if VPC security groups have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_vpc_security_group")
}

control "vpc_vpn_connection_untagged" {
  title       = "VPC VPN connections should be tagged"
  description = "Check if VPC VPN connections have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_vpc_vpn_connection")
}

control "wafv2_ip_set_untagged" {
  title       = "WAFV2 ip sets should be tagged"
  description = "Check if WAFV2 ip sets have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_wafv2_ip_set")
}

control "wafv2_regex_pattern_set_untagged" {
  title       = "WAFV2 regex pattern sets should be tagged"
  description = "Check if WAFV2 regex pattern sets have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_wafv2_regex_pattern_set")
}

control "wafv2_rule_group_untagged" {
  title       = "WAFV2 rule groups should be tagged"
  description = "Check if WAFV2 rule groups have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_wafv2_rule_group")
}

control "wafv2_web_acl_untagged" {
  title       = "WAFV2 web acls should be tagged"
  description = "Check if WAFV2 web acls have at least 1 tag."
  sql         = replace(local.untagged_sql_region, "__TABLE_NAME__", "aws_wafv2_web_acl")
}
