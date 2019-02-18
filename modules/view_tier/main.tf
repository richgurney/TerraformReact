resource "aws_s3_bucket" "react_bucket" {
  bucket = "${var.bucket_name}"
  acl = "public-read"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::${var.bucket_name}"
        },
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:PutObject",
                "s3:GetObject"
            ],
            "Resource": "arn:aws:s3:::${var.bucket_name}/*"
        }
    ]
}
EOF

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}


resource "null_resource" "s3_file_uploader" {
  provisioner "local-exec" {
    command = <<EOF
    cd presentation/ReactSampleApp
    echo "REACT_APP_HOST=http://${var.app_ip}/posts" > .env
    npm i
    npm run build
    npm run deploy
EOF
  }
  depends_on = ["aws_s3_bucket.react_bucket"]
}
