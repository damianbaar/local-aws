POC to spinup `localstack` and some deployment tools (i.e. `aws-cdk`) - to have testable playground for infrustructure.

### Before start 
#### Prerequisites
* install [`nix`](https://nixos.org/download.html)
* install [`direnv`](https://direnv.net/)

### Why
* [`nix`](https://gist.github.com/joepie91/9fdaf8244b0a83afcce204e6da127c7d)

### Startup
`localstack` is used to provide ability to test things without dependency on internet any any costs.
## Folder structure
* TODO

## Commands
Helper commands to be run everywhere.

### Environment initialization
* to start all necessary processes for running local environment, go with `start-environment` 

### Pulumi wrapper
* `deployer <command> <folder>` - `deployer stack infra/simple_lambda_python`

#### Updating `requirements`
* `refresh-deps` - command to update `virtualenv`

#### Localstack
* `start-localstack` - run `localstack` instance thru `docker-compose`
* `stop-localstack` - kill `localstack` instance thru `docker-compose`

### AWS
* to create bucket run `create-s3-bucket <your_bucket_name>`, i.e. `create-s3-bucket my-bucket`
* to run infra stack run `stack-up <your_project>`, i.e. `stack-up infra/simple_lambda_python`

#### What you will get
* [`pulumi`](https://github.com/pulumi/pulumi)
* [`localstack`](https://github.com/localstack/localstack)

### Building
* `bazel build //infra/simple_lambda_python:main`

### Internals
#### How it works
When you enter in the directory, direnv will automatically trigger the script inside .envrc.

### To learn
* https://www.youtube.com/watch?v=USDbjmxEZ_I
* https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.section.md
* https://thomazleite.com/posts/development-with-nix-python/
* https://overflowed.dev/blog/how-to-deploy-localstack-with-pulumi/

### TODO
* introduce more meaningful python `requirements` files