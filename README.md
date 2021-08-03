# AWS Tags Tool

An AWS tags checking tool.

## Quick start

1) Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```shell
brew tap turbot/tap
brew install steampipe

steampipe -v
steampipe version 0.7.1
```

2) Install the AWS plugin
```shell
steampipe plugin install aws
```

3) Clone this repo
```sh
git clone git@github.com:turbot/steampipe-mod-aws-tags
cd steampipe-mod-aws-tags
```

4) Run all benchmarks:
```shell
steampipe check all
```

### Other things to checkout

Run an individual benchmark:
```shell
steampipe check benchmark.untagged
```

Use Steampipe introspection to view all current controls:
```
steampipe query "select resource_name from steampipe_control;"
```

Run a specific control:
```shell
steampipe check control.s3_bucket_untagged
```

## Contributing

If you have an idea for additional tags controls, or just want to help maintain and extend this mod ([or others](https://github.com/topics/steampipe-mod)) we would love you to join the community and start contributing. (Even if you just want to help with the docs.)

- **[Join our Slack community →](https://join.slack.com/t/steampipe/shared_invite/zt-oij778tv-lYyRTWOTMQYBVAbtPSWs3g)** and hang out with other Mod developers.
- **[Mod developer guide →](https://steampipe.io/docs/steampipe-mods/writing-mods.md)**

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-aws-tags/blob/main/LICENSE).

`help wanted` issues:
- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [AWS Tags Mod](https://github.com/turbot/steampipe-mod-aws-tags/labels/help%20wanted)
