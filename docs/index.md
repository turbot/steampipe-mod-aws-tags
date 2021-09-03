---
repository: "https://github.com/turbot/steampipe-mod-aws-tags"
---

# AWS Tags Mod

Run tagging controls across all your AWS accounts to look for untagged resources, missing tags, resources with too many tags, and more.

## References

[AWS](https://aws.amazon.com/) provides on-demand cloud computing platforms and APIs to authenticated customers on a metered pay-as-you-go basis.

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, and codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration.

## Documentation

- **[Benchmarks and controls →](https://hub.steampipe.io/mods/turbot/aws_tags/controls)**

## Getting started

### Installation

1) Install the AWS plugin:
```shell
steampipe plugin install aws
```

2) Clone this repo:
```sh
git clone https://github.com/turbot/steampipe-mod-aws-tags.git
cd steampipe-mod-aws-tags
```

### Usage

#### Running benchmarks

Preview running all benchmarks:
```shell
steampipe check all --dry-run
```

Run all benchmarks:
```shell
steampipe check all
```

Use Steampipe introspection to view all current benchmarks:
```shell
steampipe query "select resource_name, title, description from steampipe_benchmark;"
```

Run an individual benchmark:
```shell
steampipe check benchmark.untagged
```

#### Running controls

Use Steampipe introspection to view all current controls:
```shell
steampipe query "select resource_name, title, description from steampipe_control;"
```

Run a specific control:
```shell
steampipe check control.s3_bucket_untagged
```

### Credentials

This mod uses the credentials configured in the [Steampipe AWS plugin](https://hub.steampipe.io/plugins/turbot/aws).

### Configuration

Several benchmarks have variables that can be configured to better match your environment and requirements. Each variable has a default defined in `steampipe.spvars`, but these can be overriden in several ways:

- Modify the `steampipe.spvars` file
- Remove or comment out the value in `steampipe.spvars`, after which Steampipe will prompt you for a value when running a query or check
- Pass in a value on the command line:
  ```shell
  steampipe check benchmark.mandatory --var 'mandatory_tags=["Application", "Environment", "Department", "Owner"]'
  ```
- Set an environment variable:
  ```shell
  SP_VAR_mandatory_tags='["Application", "Environment", "Department", "Owner"]' steampipe check control.ec2_instance_mandatory
  ```
  - Note: When using environment variables, if the variable is defined in `steampipe.spvars` or passed in through the command line, either of those will take precedence over the environment variable value. For more information on variable definition precedence, please see the link below.

TODO: Fix these links

These are some of the ways you can set variables, but for a full list, please see [Variables](https://hub.steampipe.io/linkhere).

For more information on variable definition precedence, please see [Variables](https://hub.steampipe.io/linkhere).

## Advanced usage

### Remediation

Using the control output and the AWS CLI, you can remediate various tagging issues.

For instance, with the results of the `ec2_instance_mandatory` control, you can add missing tags with the AWS CLI:

```bash
#!/bin/bash

OLDIFS=$IFS
IFS='#'

INPUT=$(steampipe check control.ec2_instance_mandatory --var 'mandatory_tags=["Application"]' --output csv --header=false --separator '#' | grep 'alarm')
[ -z "$INPUT" ] && { echo "No instances in alarm, aborting"; exit 0; }

while read -r group_id title description control_id control_title control_description reason resource status account_id region
do
  aws resourcegroupstaggingapi tag-resources --region ${region} --resource-arn-list ${resource} --tags Application=MyApplication
done <<< "$INPUT"

IFS=$OLDIFS
```

To remove prohibited tags from EC2 instances:
```bash
#!/bin/bash

OLDIFS=$IFS
IFS='#'

INPUT=$(steampipe check control.ec2_instance_prohibited --var 'prohibited_tags=["Password"]' --output csv --header=false --separator '#' | grep 'alarm')
[ -z "$INPUT" ] && { echo "No instances in alarm, aborting"; exit 0; }

while read -r group_id title description control_id control_title control_description reason resource status account_id region
do
  aws resourcegroupstaggingapi untag-resources --region ${region} --resource-arn-list ${resource} --tag-keys Password
done <<< "$INPUT"

IFS=$OLDIFS
```

## Get involved

* Contribute: [GitHub Repo](https://github.com/turbot/steampipe-mod-aws-tags)

* Community: [Slack Channel](https://join.slack.com/t/steampipe/shared_invite/zt-oij778tv-lYyRTWOTMQYBVAbtPSWs3g)
