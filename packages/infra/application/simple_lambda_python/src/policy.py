import pulumi
from pulumi_aws import iam, Provider

def createPolicy(provider: Provider):
  return iam.Role(
    resource_name='my-policy',
    assume_role_policy={
    "Version": "2012-10-17"
  })
