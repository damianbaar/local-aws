echo "Boostrap settings for localstack"

pulumi config set debug "true"
pulumi config set domain example.org
pulumi config set email admin@example.org
pulumi config set provider localstack
pulumi config set region us-west-1
pulumi config set stage local
pulumi config set endpoints "$(cat $ROOT_FOLDER/.localstack/endpoints.json)"  --cwd .
