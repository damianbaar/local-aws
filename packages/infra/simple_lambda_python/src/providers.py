from functools import partial
from pampy import match, _
from pulumi_aws import Provider

from configuration import Config, CloudProvider, LocalstackConfig, AWSConfig
from logger import cli_log


def getLocalStackProvider(config: LocalstackConfig):
    return Provider('localstack',
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
    return Provider('aws',
                    access_key=config.access_key,
                    secret_key=config.secret_key,
                    region=config.region)


def prepareProvider(config: Config):
    cli_log("Preparing provider {}".format(config))
    print(config)
    # match(config,
    #       LocalstackConfig(_, _), partial(getLocalStackProvider, config),
    #       AWSConfig(_, _, _, _, _), partial(getAWSProvider, config)
    #       )
