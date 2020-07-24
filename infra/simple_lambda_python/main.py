import pulumi
from pulumi_aws import s3

bucket = s3.Bucket('my-bucket')

pulumi.export('bucket_name',  bucket.id)