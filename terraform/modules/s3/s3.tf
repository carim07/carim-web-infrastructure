# This policy is applied to the main S3 bucket.  It allows CloudFront access to
# the bucket through the use of the user-agent field through which S3 and
# CloudFront share a secret. This kind of policy is not necessary for the
# redirect bucket since it doesn't store any objects, it just redirects.
data "aws_iam_policy_document" "bucket" {
  statement {
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.domain}/*",
    ]

    principals {
      type = "AWS"
      identifiers = ["*"]
    }

    condition {
      test = "StringEquals"
      variable = "aws:UserAgent"
      values = ["${var.secret}"]
    }
  }
}

resource "aws_s3_bucket" "site" {
  bucket = var.domain
  policy = "${data.aws_iam_policy_document.bucket.json}"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

}

resource "aws_s3_bucket" "www" {
  bucket = "www.${var.domain}"
  acl    = "private"

  website {
    redirect_all_requests_to = "${aws_s3_bucket.site.id}"
  }

}
