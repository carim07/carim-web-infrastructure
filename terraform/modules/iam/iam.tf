# This policy is applied to the IAM user that handles deployments for the
# static site. It basically allows full access to the main S3 bucket, and
# allows the user to create CloudFront invalidations when the site is updated
# so that the new content is rolled out quickly.
data "aws_iam_policy_document" "deploy" {
  statement {
    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "${var.bucket_arn}"
    ]
  }

  statement {
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      "${var.bucket_arn}/*"
    ]
  }

  statement {
    actions = [
      "cloudfront:CreateInvalidation"
    ]

    resources = [
      "*" # A specific resource cannot be specified here, unfortunately.
    ]
  }
}

resource "aws_iam_user" "deploy" {
  name = "${var.domain}-deploy"
  path = "/"
}

resource "aws_iam_access_key" "deploy" {
  user = "${aws_iam_user.deploy.name}"
}

resource "aws_iam_user_policy" "deploy" {
  name = "deploy"
  user = "${aws_iam_user.deploy.name}"
  policy = "${data.aws_iam_policy_document.deploy.json}"
}