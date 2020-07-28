from functools import partial
from pampy import match, _
from pulumi_aws import Provider

from configuration import Config, CloudProvider, LocalstackConfig, AWSConfig
from logger import cli_log, deployer_log


def getLocalStackProvider(config: LocalstackConfig):
    return Provider('localstack',
                    # skip_credentials_validation=True,
                    # skip_metadata_api_check=True,
                    # skip_requesting_account_id=True,
                    # s3_force_path_style=True,
                    # access_key="dupa", #config.access_key,
                    # secret_key="dupa", #config.secret_key,
                    region=config.region,
                    endpoints={
                        "s3": config.endpoints['S3'],
                        "dynamodb": config.endpoints["DynamoDB"],
                        "apigateway": config.endpoints['APIGateway'],
                        "cloudformation": config.endpoints['CloudFormation'],
                        "cloudwatch": config.endpoints['CloudWatch'],
                        "cloudwatchlogs": config.endpoints['CloudWatchLogs'],
                        "es": config.endpoints['ES'],
                        "firehose": config.endpoints['Firehose'],
                        "iam": config.endpoints['IAM'],
                        "kinesis": config.endpoints['Kinesis'],
                        "kms": config.endpoints['KMS'],
                        "lambda": config.endpoints['Lambda'],
                        "route53": config.endpoints['Route53'],
                        "redshift": config.endpoints['Redshift'],
                        "s3": config.endpoints['S3'],
                        "ses": config.endpoints['SES'],
                        "sns": config.endpoints['SNS'],
                        "sqs": config.endpoints['SQS'],
                        "ssm": config.endpoints['SSM'],
                        "sts": config.endpoints['STS'],
                    })


def getAWSProvider(config: AWSConfig):
    return Provider('aws',
                    access_key=config.access_key,
                    secret_key=config.secret_key,
                    region=config.region)


def prepareProvider(config: Config) -> Provider:
    cli_log(f'Preparing provider {config}')
    provider = getLocalStackProvider(config)
    cli_log(f'Provider {provider}')
    return provider
    # match(config,
    #       LocalstackConfig(_, _), partial(getLocalStackProvider, config),
    #       AWSConfig(_, _, _, _, _), partial(getAWSProvider, config)
    #       )
