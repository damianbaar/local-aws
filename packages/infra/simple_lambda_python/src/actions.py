import pulumi
from pulumi_aws import s3, Provider

from policy import createPolicy
from logger import cli_log
from configuration import Config, CloudProvider, LocalstackConfig, AWSConfig, make_config
from providers import prepareProvider


def infraActions():
    config = make_config()
    provider = prepareProvider(config)
    bucket = s3.Bucket('my-bucket')
    # createPolicy(provider)
    pulumi.export('bucket_name',  bucket.id)


def runStack():
    infraActions()
