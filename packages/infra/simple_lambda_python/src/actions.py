import pulumi
from pulumi_aws import s3

from policy import createPolicy
from logger import cli_log
from configuration import Config, CloudProvider, LocalstackConfig, AWSConfig, make_config
from providers import prepareProvider


def infraActions():
    bucket = s3.Bucket('my-bucket')
    createPolicy()
    pulumi.export('bucket_name',  bucket.id)


def runStack():
    config = make_config()
    prepareProvider(config)
    infraActions()
