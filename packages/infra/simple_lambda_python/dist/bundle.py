#!/usr/bin/env python


import contextlib as __stickytape_contextlib

@__stickytape_contextlib.contextmanager
def __stickytape_temporary_dir():
    import tempfile
    import shutil
    dir_path = tempfile.mkdtemp()
    try:
        yield dir_path
    finally:
        shutil.rmtree(dir_path)

with __stickytape_temporary_dir() as __stickytape_working_dir:
    def __stickytape_write_module(path, contents):
        import os, os.path

        def make_package(path):
            parts = path.split("/")
            partial_path = __stickytape_working_dir
            for part in parts:
                partial_path = os.path.join(partial_path, part)
                if not os.path.exists(partial_path):
                    os.mkdir(partial_path)
                    open(os.path.join(partial_path, "__init__.py"), "w").write("\n")

        make_package(os.path.dirname(path))

        full_path = os.path.join(__stickytape_working_dir, path)
        with open(full_path, "w") as module_file:
            module_file.write(contents)

    import sys as __stickytape_sys
    __stickytape_sys.path.insert(0, __stickytape_working_dir)

    __stickytape_write_module('actions.py', "import pulumi\nfrom pulumi_aws import s3\n\nfrom policy import createPolicy\nfrom logger import cli_log\nfrom configuration import Config, CloudProvider, LocalstackConfig, AWSConfig, make_config\nfrom providers import prepareProvider\n\n\ndef infraActions():\n    bucket = s3.Bucket('my-bucket')\n    createPolicy()\n    pulumi.export('bucket_name',  bucket.id)\n\n\ndef runStack():\n    config = make_config()\n    prepareProvider(config)\n    infraActions()\n")
    __stickytape_write_module('policy.py', 'import pulumi\nfrom pulumi_aws import iam\n\ndef createPolicy():\n  return iam.Role(\n    resource_name=\'my-policy\',\n    assume_role_policy={\n    "Version": "2012-10-17"\n  })')
    __stickytape_write_module('logger.py', 'import functools\nfrom pulumi import log\n\ndef log_local(message, subsystem):\n    """Write the contents of \'message\' to the specified subsystem."""\n    print(\'%s: %s\' % (subsystem, message))\n\ncli_log = functools.partial(log_local, subsystem=\'cli\')\ndeployer_log = log')
    __stickytape_write_module('configuration.py', 'from dataclasses import dataclass, field\nfrom boto3.session import Session\nfrom pampy import match, _\nfrom environment import get_environment_config, EnvironmentDescriptor, CloudProvider, TargetEnvironment, Region\n\n\n@dataclass(frozen=True)\nclass Config():\n    provider: CloudProvider = CloudProvider.LOCAL\n    stage: TargetEnvironment = TargetEnvironment.LOCAL\n\n\n@dataclass(frozen=True)\nclass AWSConfig(Config):\n    region: Region = Region.EU_EAST_1\n    access_key: str = ""\n    secret_key: str = ""\n\n\n@dataclass(frozen=True)\nclass LocalstackConfig(AWSConfig):\n    endpoints: dict = None\n\n\ndef make_config() -> Config:\n    env = get_environment_config()\n    return match(env,\n                 EnvironmentDescriptor(\n                     CloudProvider.LOCAL.value, _, _, _, _, _, _),\n                 LocalstackConfig(\n                     provider=env.provider,\n                     stage=env.stage,\n                     region=env.region,\n                     access_key=env.access_key,\n                     secret_key=env.secret_key,\n                     endpoints=env.endpoints_config\n                 ),\n\n                 EnvironmentDescriptor(\n                     CloudProvider.AWS.value, _, _, _, _, _, _),\n                 AWSConfig(\n                     provider=env.provider,\n                     stage=env.stage,\n                     region=env.region,\n                     access_key=env.access_key,\n                     secret_key=env.secret_key\n                 ))\n')
    __stickytape_write_module('environment.py', 'import json\nimport os\n\nfrom dataclasses import dataclass, field\nfrom enum import Enum\nfrom pulumi import Config\n\n\n# INFO / TODO: can be dynamically obtained from here\n# s3_regions = Session().get_available_regions(\'s3\')\n\ndef loadJSONFile(configToLoad):\n    return json.loads(configToLoad)\n\n\nclass Region(Enum):\n    US_WEST_1 = "us-west-1"\n    US_EAST_1 = "us-east-1"\n    EU_WEST_1 = "eu-west-1"\n    EU_EAST_1 = "eu-east-1"\n\n\nclass TargetEnvironment(Enum):\n    LOCAL = "local"\n    STAGING = "staging"\n    PROD = "prod"\n\n\nclass CloudProvider(Enum):\n    LOCAL = "localstack"\n    AWS = "aws"\n    AZURE = "azure"\n\n\n@dataclass\nclass EnvironmentDescriptor():\n    provider: CloudProvider = CloudProvider.LOCAL\n    stage: TargetEnvironment = TargetEnvironment.LOCAL\n    region: Region = ""\n    name: str = ""\n    access_key: str = ""\n    secret_key: str = ""\n    endpoints_config: json = None\n\n\ndef read_pulumi_config() -> EnvironmentDescriptor:\n    moduleCfg = Config()\n    awsCfg = Config("aws")\n\n    return EnvironmentDescriptor(\n        provider=moduleCfg.require(\'provider\'),\n        stage=moduleCfg.require(\'stage\'),\n        region=awsCfg.require(\'region\'),\n        name=moduleCfg.require(\'name\'),\n        access_key=awsCfg.get_secret(\'access_key\'),\n        secret_key=awsCfg.get_secret(\'secret_key\'),\n        endpoints_config=loadJSONFile(moduleCfg.require(\'endpoints\')),\n    )\n\n\ndef get_environment_config() -> EnvironmentDescriptor:\n    return read_pulumi_config()\n')
    __stickytape_write_module('providers.py', 'from functools import partial\nfrom pampy import match, _\nfrom pulumi_aws import Provider\n\nfrom configuration import Config, CloudProvider, LocalstackConfig, AWSConfig\nfrom logger import cli_log\n\n\ndef getLocalStackProvider(config: LocalstackConfig):\n    return Provider(\'localstack\',\n                    skip_credentials_validation=True,\n                    skip_metadata_api_check=True,\n                    s3_force_path_style=True,\n                    access_key=config.access_key,\n                    secret_key=config.secret_key,\n                    region=config.region,\n                    endpoints={\n                        "s3": config.endpoints[\'S3\'],\n                        "apigatetway": config.endpoints["APIGateway"],\n                        "dynamodb": config.endpoints["DynamoDB"]\n                    })\n\n\ndef getAWSProvider(config: AWSConfig):\n    return Provider(\'aws\',\n                    access_key=config.access_key,\n                    secret_key=config.secret_key,\n                    region=config.region)\n\n\ndef prepareProvider(config: Config):\n    cli_log("Preparing provider {}".format(config))\n    print(config)\n    # match(config,\n    #       LocalstackConfig(_, _), partial(getLocalStackProvider, config),\n    #       AWSConfig(_, _, _, _, _), partial(getAWSProvider, config)\n    #       )\n')
    from actions import runStack
    
    runStack()
    