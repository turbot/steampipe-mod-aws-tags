# AWS Tags Tool

An AWS tags checking tool that can be used to look for untagged resources, missing tags, resources with too many tags, and more.

## Getting started

### Installation

1) Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```shell
brew tap turbot/tap
brew install steampipe

steampipe -v
steampipe version 0.8.0
```

2) Install the AWS plugin:
```shell
steampipe plugin install aws
```

3) Clone this repo:
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

### Configuration

Several benchmarks have variables that can be configured to better match your environment and requirements. Each variable has a default defined in `steampipe.spvars`, but these can be overriden in several ways:

- Modify the `steampipe.spvars` file
- Remove or comment out the value in `steampipe.spvars`, after which Steampipe will prompt you for a value when running a query or check
- Pass in a value on the command line:
  ```shell
  steampipe check benchmark.mandatory --var 'mandatory_tags=["application", "environment", "department", "owner"]'
  ```
- Set an environment variable:
  ```shell
  SP_VAR_mandatory_tags='["application", "environment", "department", "owner"]' steampipe check control.ec2_instance_mandatory
  ```
  - Note: When using environment variables, if the variable is defined in `steampipe.spvars` or passed in through the command line, either of those will take precedence over the environment variable value. For more information on variable definition precedence, please see the link below.

These are some of the ways you can set variables, but for a full list, please see [Variables](https://hub.steampipe.io/linkhere).

For more information on variable definition precedence, please see [Variables](https://hub.steampipe.io/linkhere).

## Contributing

If you have an idea for additional tags controls, or just want to help maintain and extend this mod ([or others](https://github.com/topics/steampipe-mod)) we would love you to join the community and start contributing. (Even if you just want to help with the docs.)

- **[Join our Slack community →](https://join.slack.com/t/steampipe/shared_invite/zt-oij778tv-lYyRTWOTMQYBVAbtPSWs3g)** and hang out with other Mod developers.
- **[Mod developer guide →](https://steampipe.io/docs/steampipe-mods/writing-mods.md)**

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-aws-tags/blob/main/LICENSE).

`help wanted` issues:
- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [AWS Tags Mod](https://github.com/turbot/steampipe-mod-aws-tags/labels/help%20wanted)
