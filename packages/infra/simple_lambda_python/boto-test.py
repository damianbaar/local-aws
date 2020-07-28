import boto3

s3 = boto3.client('s3',
                  endpoint_url="http://localhost:4572",
                  use_ssl=False,
                  aws_access_key_id="fake",
                  aws_secret_access_key='fake',
                  region_name="us-east-1")

print(s3.list_buckets())
