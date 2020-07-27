from dataclasses import dataclass, field
from boto3.session import Session
from pampy import match, _
from environment import get_environment_config, EnvironmentDescriptor, CloudProvider, TargetEnvironment, Region


@dataclass(frozen=True)
class Config():
    provider: CloudProvider = CloudProvider.LOCAL
    stage: TargetEnvironment = TargetEnvironment.LOCAL


@dataclass(frozen=True)
class AWSConfig(Config):
    region: Region = Region.EU_EAST_1
    access_key: str = ""
    secret_key: str = ""


@dataclass(frozen=True)
class LocalstackConfig(AWSConfig):
    endpoints: dict = None


def make_config() -> Config:
    env = get_environment_config()
    return match(env,
                 EnvironmentDescriptor(
                     CloudProvider.LOCAL.value, _, _, _, _, _, _),
                 LocalstackConfig(
                     provider=env.provider,
                     stage=env.stage,
                     region=env.region,
                     access_key=env.access_key,
                     secret_key=env.secret_key,
                     endpoints=env.endpoints_config
                 ),

                 EnvironmentDescriptor(
                     CloudProvider.AWS.value, _, _, _, _, _, _),
                 AWSConfig(
                     provider=env.provider,
                     stage=env.stage,
                     region=env.region,
                     access_key=env.access_key,
                     secret_key=env.secret_key
                 ))
