"""An AWS Python Pulumi program"""

import pulumi
from pulumi_aws import s3, Provider

provider = Provider('aws',
                    skip_credentials_validation=True,
                    skip_metadata_api_check=True,
                    skip_region_validation=True,
                    skip_requesting_account_id=True,
                    s3_force_path_style=True,
                    skip_get_ec2_platforms=True,
                    access_key="fake",  # config.access_key,
                    secret_key="fake",  # config.secret_key,
                    region="eu-west-1",
                    # profile="localstack",
                    endpoints=[
                        {
                         's3': 'http://localhost:4572',
                         }
                    ])

# Create an AWS resource (S3 Bucket)
bucket = s3.Bucket('my-bucket-20')

# Export the name of the bucket
pulumi.export('bucket_name', bucket.id)
