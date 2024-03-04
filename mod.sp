mod "aws_tags" {
  # hub metadata
  title         = "AWS Tags"
  description   = "Run tagging controls across all your AWS accounts using Powerpipe and Steampipe."
  color         = "#FF9900"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/aws-tags.svg"
  categories    = ["aws", "tags", "public cloud"]

  opengraph {
    title       = "Powerpipe Mod for AWS Tags"
    description = "Run tagging controls across all your AWS accounts using Powerpipe and Steampipe."
    image       = "/images/mods/turbot/aws-tags-social-graphic.png"
  }

  // v0.81.0 migrated the last tables to AWS SDK Go v2 which changed how empty tags were returned
  require {
    plugin "aws" {
      min_version = "0.81.0"
    }
  }
}

