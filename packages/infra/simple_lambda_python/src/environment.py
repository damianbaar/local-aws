from dataclasses import dataclass, field
import json
import os
from dotenv import load_dotenv
from configuration import Config, Provider


def loadJSONFile(configToLoad):
    return json.dump(configToLoad, open(configToLoad, "r"))


@dataclass
class EnvironmentDescriptor():
    stage: str
    stage: str
    provider: str
    region: str
    name: str
    access_key: str
    secret_key: str
    endpoints_config: str


def get_env_vars() -> EnvironmentDescriptor:
    return EnvironmentDescriptor(
        stage=os.environ['STAGE'],
        provider=os.environ['PROVIDER'],
        region=os.environ['REGION'],
        name=os.environ['NAME'],
        access_key=os.environ['ACCESS_KEY'],
        secret_key=os.environ['SECRET_KEY'],
        endpoints_config=loadJSONFile(os.environ['ENDPOINTS_CONFIG'])
    )


def get_environment_config() -> EnvironmentDescriptor:
    load_dotenv(verbfose=True)
    return get_env_vars()
