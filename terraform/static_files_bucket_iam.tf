resource "aws_iam_user" "static_files_bucket_iam" {
  name = var.static_bucket_iam_role_name
  path = "/skladis/"
}

resource "aws_iam_access_key" "static_files_bucket_iam" {
  user = aws_iam_user.static_files_bucket_iam.name
}

resource "aws_iam_user_policy" "default" {
  name = var.static_bucket_iam_policy_name
  user = aws_iam_user.static_files_bucket_iam.name

  policy = templatefile("static_files_bucket_iam.json.tmpl", {
    s3_bucket_arn = aws_s3_bucket.skladis_static_bucket.arn
  })
}
