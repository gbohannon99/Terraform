resource "aws_s3_bucket" "cloud_bucket" {
  bucket = "gmb-cloudfront-bucket"

  acl = "public-read"

  versioning {
    enabled = true
  }

  tags = {
    Name = "Cloud-Bucket"
  }
}

//This is a setting to improve security access and control
//    Used to create an identity that can be used to restrict access to the S3 bucket that is being used at the origin
resource "aws_cloudfront_origin_access_identity" "cloud_origin" {
  comment = "My cloudfront origin access identity for my project"
}


resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.cloud_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.cloud_bucket.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloud_origin.cloudfront_access_identity_path
    }
  }

  enabled             = true
  default_root_object = "index.html"

  /*
          logging_config{
              bucket = <ENTER EXISTING BUCKET NAME> i.e. "mylogs.s3.amazon.com"
              prefix = <ENTER PREFIX> i.e. "myprefix"
          }
    */

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.cloud_bucket.id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

}




//This bucket policy is to create a means of security that will help protect our s3 bucket
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.cloud_bucket.id
  policy = jsonencode({

    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",

        "Principal": {
          "AWS" : "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.cloud_origin.id}"
        },

        "Action" : [
          "s3:GetObject",
          "s3:ListBucket"
        ],

        "Resource" : [
          "${aws_s3_bucket.cloud_bucket.arn}",
          "${aws_s3_bucket.cloud_bucket.arn}/*"
        ]

      }
    ]
  })
}



