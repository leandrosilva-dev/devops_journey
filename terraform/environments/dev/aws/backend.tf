terraform {
    backend "s3" {
        bucket         = "devops-journey-dev-tfstate-bucket"
        key            = "environments/dev/aws/terraform.tfstate"
        region         = "us-east-2"
        encrypt        = true
        use_lockfile   = true # Enable S3 native state locking
    }
}