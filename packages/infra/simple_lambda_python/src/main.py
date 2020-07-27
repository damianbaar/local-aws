from pampy import match, _
import pulumi
from pulumi_aws import s3, Provider
import functools

from policy import createPolicy
from logger import cli_log
from configuration import Config, CloudProvider, LocalstackConfig, AWSConfig, make_config


def getLocalStackProvider(config: LocalstackConfig):
    return Provider("localstack",
                    skip_credentials_validation=True,
                    skip_metadata_api_check=True,
                    s3_force_path_style=True,
                    access_key=config.access_key,
                    secret_key=config.secret_key,
                    region=config.region,
                    endpoints={
                        "s3": config.endpoints['S3'],
                        "apigatetway": config.endpoints["APIGateway"],
                        "dynamodb": config.endpoints["DynamoDB"]
                    })


def getAWSProvider(config: AWSConfig):
    return Provider("aws",
                    access_key=config.access_key,
                    secret_key=config.secret_key,
                    region=config.region)


def prepareProvider(config: Config):
    cli_log("Running provider")

    match(config,
          Config(provider=CloudProvider.LOCAL), functools.partial(
              getLocalStackProvider, config),
          Config(provider=CloudProvider.AWS), functools.partial(
              getAWSProvider, config)
          )


def run():
    config = make_config(Config())
    prepareProvider(CloudProvider.LOCAL)
    bucket = s3.Bucket('my-bucket')
    createPolicy()
    pulumi.export('bucket_name',  bucket.id)

# seq(1, 2, 3, 4)\
#     .map(lambda x: x * 2)\
#     .filter(lambda x: x > 4)\
#     .reduce(lambda x, y: x + y)
