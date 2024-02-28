# AWS Tags Mod for Steampipe

An AWS tags checking tool that can be used to look for untagged resources, missing tags, resources with too many tags, and more.

Run checks in a dashboard:

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-aws-tags/main/docs/aws_tags_dashboard.png)

Or in a terminal:

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-aws-tags/main/docs/aws_tags_mod_terminal.png)

## Documentation

- **[Benchmarks and controls →](https://hub.steampipe.io/mods/turbot/aws_tags/controls)**

## Getting Started

### Installation

Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install steampipe
```

Install the AWS plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install aws
```

Clone:

```sh
git clone https://github.com/turbot/steampipe-mod-aws-tags.git
cd steampipe-mod-aws-tags
```

### Usage

Start your dashboard server to get started:

```sh
steampipe dashboard
```

By default, the dashboard interface will then be launched in a new browser
window at http://localhost:9194. From here, you can run benchmarks by
selecting one or searching for a specific one.

Instead of running benchmarks in a dashboard, you can also run them within your
terminal with the `steampipe check` command:

Run all benchmarks:

```sh
steampipe check all
```

Run a single benchmark:

```sh
steampipe check benchmark.untagged
```

Run a specific control:

```sh
steampipe check control.s3_bucket_untagged
```

Different output formats are also available, for more information please see
[Output Formats](https://steampipe.io/docs/reference/cli/check#output-formats).

### Credentials

This mod uses the credentials configured in the [Steampipe AWS plugin](https://hub.steampipe.io/plugins/turbot/aws).

### Configuration

Several benchmarks have [input variables](https://steampipe.io/docs/using-steampipe/mod-variables) that can be configured to better match your environment and requirements. Each variable has a default defined in its source file, e.g., `controls/limit.sp`, but these can be overriden in several ways:

- Copy and rename the `steampipe.spvars.example` file to `steampipe.spvars`, and then modify the variable values inside that file
- Pass in a value on the command line:
  ```shell
  steampipe check benchmark.mandatory --var 'mandatory_tags=["Application", "Environment", "Department", "Owner"]'
  ```
- Set an environment variable:
  ```shell
  SP_VAR_mandatory_tags='["Application", "Environment", "Department", "Owner"]' steampipe check control.ec2_instance_mandatory
  ```
  - Note: When using environment variables, if the variable is defined in `steampipe.spvars` or passed in through the command line, either of those will take precedence over the environment variable value. For more information on variable definition precedence, please see the link below.

These are only some of the ways you can set variables. For a full list, please see [Passing Input Variables](https://steampipe.io/docs/using-steampipe/mod-variables#passing-input-variables).

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

### Common and Tag Dimensions

The benchmark queries use common properties (like `account_id`, `connection_name` and `region`) and tags that are defined in the form of a default list of strings in the `mod.sp` file. These properties can be overwritten in several ways:

- Copy and rename the `steampipe.spvars.example` file to `steampipe.spvars`, and then modify the variable values inside that file
- Pass in a value on the command line:

  ```shell
  steampipe check benchmark.limit --var 'common_dimensions=["account_id", "connection_name", "region"]'
  ```

  ```shell
  steampipe check benchmark.limit --var 'tag_dimensions=["Environment", "Owner"]'
  ```

- Set an environment variable:

  ```shell
  SP_VAR_common_dimensions='["account_id", "connection_name", "region"]' steampipe check control.ebs_snapshot_tag_limit
  ```

  ```shell
  SP_VAR_tag_dimensions='["Environment", "Owner"]' steampipe check control.ebs_snapshot_tag_limit
  ```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Steampipe](https://steampipe.io) is a product produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). It is distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #steampipe on Slack →](https://turbot.com/community/join)**

Want to help but don't know where to start? Pick up one of the `help wanted` issues:

- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [AWS Tags Mod](https://github.com/turbot/steampipe-mod-aws-tags/labels/help%20wanted)
