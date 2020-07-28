from functools import partial
from pampy import match, _
from pulumi_aws import Provider

from configuration import Config, CloudProvider, LocalstackConfig, AWSConfig
from logger import cli_log, deployer_log


def getLocalStackProvider(config: LocalstackConfig):
  return Provider('localstack',
                    # INFO this has to be followed by configuration
                    # https://github.com/pulumi/pulumi-aws/issues/873
                    # all properties are defined within stack
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

def getAWSProvider(config: AWSConfig):
    return Provider('aws',
                    access_key=config.access_key,
                    secret_key=config.secret_key,
                    region=config.region)


def prepareProvider(config: Config) -> Provider:
    cli_log(f'Preparing provider {config}')
    provider = getLocalStackProvider(config)
    return provider
    # match(config,
    #       LocalstackConfig(_, _), partial(getLocalStackProvider, config),
    #       AWSConfig(_, _, _, _, _), partial(getAWSProvider, config)
    #       )
