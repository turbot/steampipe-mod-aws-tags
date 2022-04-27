// Benchmarks and controls for specific services should override the "service" tag
locals {
  aws_tags_common_tags = {
    category = "Tagging"
    plugin   = "aws"
    service  = "AWS"
  }
}

mod "aws_tags" {
  # hub metadata
  title         = "AWS Tags"
  description   = "Run tagging controls across all your AWS accounts using Steampipe."
  color         = "#FF9900"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/aws-tags.svg"
  categories    = ["aws", "tags", "public cloud"]

  opengraph {
    title        = "Steampipe Mod for AWS Tags"
    description  = "Run tagging controls across all your AWS accounts using Steampipe."
    image        = "/images/mods/turbot/aws-tags-social-graphic.png"
  }
}
