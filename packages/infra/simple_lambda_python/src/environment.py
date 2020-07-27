import json
import os

from dataclasses import dataclass, field
from enum import Enum
from pulumi import Config


# INFO / TODO: can be dynamically obtained from here
# s3_regions = Session().get_available_regions('s3')

def loadJSONFile(configToLoad):
    return json.loads(configToLoad)


class Region(Enum):
    US_WEST_1 = "us-west-1"
    US_EAST_1 = "us-east-1"
    EU_WEST_1 = "eu-west-1"
    EU_EAST_1 = "eu-east-1"


class TargetEnvironment(Enum):
    LOCAL = "local"
    STAGING = "staging"
    PROD = "prod"


class CloudProvider(Enum):
    LOCAL = "localstack"
    AWS = "aws"
    AZURE = "azure"


@dataclass
class EnvironmentDescriptor():
    provider: CloudProvider = CloudProvider.LOCAL
    stage: TargetEnvironment = TargetEnvironment.LOCAL
    region: Region = ""
    name: str = ""
    access_key: str = ""
    secret_key: str = ""
    endpoints_config: json = None


def read_pulumi_config() -> EnvironmentDescriptor:
    moduleCfg = Config()
    awsCfg = Config("aws")

    return EnvironmentDescriptor(
        provider=moduleCfg.require('provider'),
        stage=moduleCfg.require('stage'),
        region=awsCfg.require('region'),
        name=moduleCfg.require('name'),
        access_key=awsCfg.get_secret('access_key'),
        secret_key=awsCfg.get_secret('secret_key'),
        endpoints_config=loadJSONFile(moduleCfg.require('endpoints')),
    )


def get_environment_config() -> EnvironmentDescriptor:
    return read_pulumi_config()
