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

variable "common_dimensions" {
  type        = list(string)
  description = "A list of common dimensions to add to each control."
  # Define which common dimensions should be added to each control.
  # - account_id
  # - connection_name (_ctx ->> 'connection_name')
  # - region
  default     = [ "account_id", "region" ]
}

locals {

  # Local internal variable to build the SQL select clause for common
  # dimensions using a table name qualifier if required. Do not edit directly.
  common_dimensions_qualifier_sql = <<-EOQ
  %{~ if contains(var.common_dimensions, "connection_name") }, __QUALIFIER___ctx ->> 'connection_name' as connection_name%{ endif ~}
  %{~ if contains(var.common_dimensions, "region") }, __QUALIFIER__region%{ endif ~}
  %{~ if contains(var.common_dimensions, "account_id") }, __QUALIFIER__account_id%{ endif ~}
  EOQ

}

locals {

  # Local internal variable with the full SQL select clause for common
  # dimensions. Do not edit directly.
  common_dimensions_sql = replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "")

}