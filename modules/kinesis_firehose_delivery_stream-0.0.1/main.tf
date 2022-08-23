terraform {
  required_version = "> 0.14.0"
}

// Data
// Resources

resource "aws_kinesis_firehose_delivery_stream" "this" {
  name        = var.name
  destination = var.destination

  s3_configuration {
    role_arn   = var.s3_configuration_role_arn
    bucket_arn = var.s3_configuration_bucket_arn
  }

  lifecycle {
    ignore_changes = [
      tags["LogDeliveryEnabled"],
    ]
  }


  tags = merge(
    {
      "Name" = var.name
    },
    var.tags,
  )

}