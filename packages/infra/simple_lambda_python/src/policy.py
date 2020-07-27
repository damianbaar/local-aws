import pulumi
from pulumi_aws import iam

def createPolicy():
  return iam.Role(
    resource_name='my-policy',
    assume_role_policy={
    "Version": "2012-10-17"
  })