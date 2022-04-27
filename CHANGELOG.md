## v0.4 [2022-04-27]

_Enhancements_

- Added `category`, `service`, and `type` tags to benchmarks. ([#13](https://github.com/turbot/steampipe-mod-aws-tags/pull/13))

## v0.3 [2022-03-23]

_What's new?_

- Added default values to all variables (set to the same values in `steampipe.spvars.example`)
- Added `*.spvars` and `*.auto.spvars` files to `.gitignore`
- Renamed `steampipe.spvars` to `steampipe.spvars.example`, so the variable default values will be used initially. To use this example file instead, copy `steampipe.spvars.example` as a new file `steampipe.spvars`, and then modify the variable values in it. For more information on how to set variable values, please see [Input Variable Configuration](https://hub.steampipe.io/mods/turbot/aws_tags#configuration).

## v0.2 [2021-11-15]

_Enhancements_

- `README.md` and `docs/index.md` files now include the console output image

## v0.1 [2021-09-09]

_What's new?_

New control types:
- Untagged: Find resources with no tag.
- Prohibited: Find prohibited tag names.
- Mandatory: Ensure mandatory tags are set.
- Limit: Detect when the tag limit is nearly met.

For 71 resource types:
- accessanalyzer_analyzer
- api_gateway_stage
- cloudfront_distribution
- cloudtrail_trail
- cloudwatch_alarm
- cloudwatch_log_group
- codebuild_project
- codecommit_repository
- codepipeline_pipeline
- config_rule
- dax_cluster
- directory_service_directory
- dms_replication_instance
- dynamodb_table
- ebs_snapshot
- ebs_volume
- ec2_application_load_balancer
- ec2_classic_load_balancer
- ec2_gateway_load_balancer
- ec2_instance
- ec2_network_load_balancer
- ec2_reserved_instance
- ecr_repository
- ecs_container_instance
- ecs_service
- efs_file_system
- eks_addon
- eks_cluster
- eks_identity_provider_config
- elastic_beanstalk_application
- elastic_beanstalk_environment
- elasticache_cluster
- elasticsearch_domain
- eventbridge_rule
- guardduty_detector
- iam_role
- iam_server_certificate
- iam_user
- inspector_assessment_template
- kinesis_firehose_delivery_stream
- kms_key
- lambda_function
- rds_db_cluster
- rds_db_cluster_parameter_group
- rds_db_cluster_snapshot
- rds_db_instance
- rds_db_option_group
- rds_db_parameter_group
- rds_db_snapshot
- rds_db_subnet_group
- redshift_cluster
- route53_domain
- route53_resolver_endpoint
- s3_bucket
- sagemaker_endpoint_configuration
- sagemaker_model
- sagemaker_notebook_instance
- sagemaker_training_job
- secretsmanager_secret
- ssm_parameter
- tagging_resource
- vpc
- vpc_eip
- vpc_nat_gateway
- vpc_network_acl
- vpc_security_group
- vpc_vpn_connection
- wafv2_ip_set
- wafv2_regex_pattern_set
- wafv2_rule_group
- wafv2_web_acl
