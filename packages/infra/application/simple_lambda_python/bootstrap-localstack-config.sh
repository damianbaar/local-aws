echo "Boostrap settings for localstack"

echo "-- setting up project values --"
pulumi config set debug "true"
pulumi config set domain example.org
pulumi config set email admin@example.org
pulumi config set stage local
pulumi config set name pulumi-playground

echo "-- setting up AWS values --"
# because of ... https://github.com/pulumi/pulumi-aws/issues/873
pulumi config set provider localstack
pulumi config set aws:region us-west-1
pulumi config set aws:skipCredentialsValidation true
pulumi config set aws:skipMetadataApiCheck true
pulumi config set aws:skipRequestingAccountId true

echo "-- setting up Localstack endpoints --"
pulumi config set --path aws:endpoints[0].s3 $(getEndpoint S3)
pulumi config set --path aws:endpoints[1].dynamodb $(getEndpoint DynamoDB)
pulumi config set --path aws:endpoints[2].iam $(getEndpoint IAM)
pulumi config set --path aws:endpoints[3].apigateway $(getEndpoint APIGateway)