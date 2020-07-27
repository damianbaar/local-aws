from dataclasses import dataclass, field
from enum import Enum
from boto3.session import Session
from pampy import match, _
from environment import get_environment_config, EnvironmentDescriptor


class CloudProvider(Enum):
    LOCAL = "localstack"
    AWS = "aws"
    AZURE = "azure"


# can be dynamically obtained from here
# s3_regions = Session().get_available_regions('s3')

class Region(Enum):
    US_WEST_1 = "us-west-1"
    US_EAST_1 = "us-east-1"
    EU_WEST_1 = "eu-west-1"
    EU_EAST_1 = "eu-east-1"


class Stage(Enum):
    LOCAL = "local"
    STAGING = 2
    PROD = 3


@dataclass(frozen=True)
class Config():
    provider: CloudProvider = field(default=CloudProvider.LOCAL)
    stage: Stage = field(default=Stage.LOCAL)


@dataclass
class AWSConfig(Config):
    region: Region = field(default=Region.EU_EAST_1)
    access_key: str
    secret_key: str


@dataclass
class LocalstackConfig(AWSConfig):
    endpoints: dict


def make_config(overridings: Config = Config()) -> Config:
    env = get_environment_config()

    return match(env,
                 EnvironmentDescriptor(provider=CloudProvider.LOCAL), LocalstackConfig(
                     provider=env.provider,
                     stage=env.stage,
                     region=env.region,
                     access_key=env.access_key,
                     secret_key=env.secret_key,
                     endpoints=env.endpoints_config
                 ),
                 EnvironmentDescriptor(provider=CloudProvider.AWS), AWSConfig(
                     provider=env.provider,
                     stage=env.stage,
                     region=env.region,
                     access_key=env.access_key,
                     secret_key=env.secret_key,
                 )
                 )
