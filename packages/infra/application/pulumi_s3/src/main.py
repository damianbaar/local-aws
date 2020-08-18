"""An AWS Python Pulumi program"""

import pulumi
from pulumi_aws import s3, Provider

provider = Provider('aws')

# Create an AWS resource (S3 Bucket)
bucket = s3.Bucket('my-bucket-20')

# Export the name of the bucket
pulumi.export('bucket_name', bucket.id)
