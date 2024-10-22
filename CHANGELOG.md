## v1.0.0 [2024-10-22]

This mod now requires [Powerpipe](https://powerpipe.io). [Steampipe](https://steampipe.io) users should check the [migration guide](https://powerpipe.io/blog/migrating-from-steampipe).

## v0.13 [2024-03-15]

_Bug fixes_

- Removed the `powerpipe.ppvars` file. ([#47](https://github.com/turbot/steampipe-mod-aws-tags/pull/47))

## v0.12 [2024-03-06]

_Powerpipe_

[Powerpipe](https://powerpipe.io) is now the preferred way to run this mod!  [Migrating from Steampipe →](https://powerpipe.io/blog/migrating-from-steampipe)

All v0.x versions of this mod will work in both Steampipe and Powerpipe, but v1.0.0 onwards will be in Powerpipe format only.

_Enhancements_

- Focus documentation on Powerpipe commands.
- Show how to combine Powerpipe mods with Steampipe plugins.

## v0.11 [2023-11-03]

_Breaking changes_

- Updated the plugin dependency section of the mod to use `min_version` instead of `version`. ([#41](https://github.com/turbot/steampipe-mod-aws-tags/pull/41))

## v0.10 [2023-08-08]

_Bug fixes_

- Fixed the `untagged` benchmark to correctly check if resources have tags or not. ([#37](https://github.com/turbot/steampipe-mod-aws-tags/pull/37)) (Thanks [@brad-webb](https://github.com/brad-webb) for the contribution!!)
- Fixed the `expected_tag_values` benchmark to skip resources where either tags are not set or there are no matching tag keys. ([#33](https://github.com/turbot/steampipe-mod-aws-tags/pull/33))

## v0.9 [2023-05-03]

_What's new?_

- Added the Expected Tag Values benchmark (`steampipe check benchmark.expected_tag_values`), which allows users to check if tags with specific keys are using allowed values. ([#27](https://github.com/turbot/steampipe-mod-aws-tags/pull/27)) (Thanks to [@rinzool](https://github.com/rinzool) for the new benchmark!)

_Dependencies_

- AWS plugin `v0.81.0` or higher is now required.

## v0.8 [2023-03-10]

_What's new?_

- Added `tags` as dimensions to group and filter findings. (see [var.tag_dimensions](https://hub.steampipe.io/mods/turbot/aws_tags/variables)) ([#25](https://github.com/turbot/steampipe-mod-aws-tags/pull/25))
- Added `connection_name` in the common dimensions to group and filter findings. (see [var.common_dimensions](https://hub.steampipe.io/mods/turbot/aws_tags/variables)) ([#25](https://github.com/turbot/steampipe-mod-aws-tags/pull/25))

## v0.7 [2022-11-03]

_Enhancements_

- Updated the queries of `Untagged` benchmark (`steampipe check benchmark.untagged`) controls to also check if the value of the `tags` column is `{}` besides checking for `null`. ([#20](https://github.com/turbot/steampipe-mod-aws-tags/pull/20))

## v0.6 [2022-09-12]

_Breaking changes_

- Removed the following controls as they're redundant with all other controls:
  - `tagging_resource_mandatory`
  - `tagging_resource_prohibited`
  - `tagging_resource_tag_limit`
  - `tagging_resource_untagged`

## v0.5 [2022-05-09]

_Enhancements_

- Updated docs/index.md and README with new dashboard screenshots and latest format. ([#16](https://github.com/turbot/steampipe-mod-aws-tags/pull/16))

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
