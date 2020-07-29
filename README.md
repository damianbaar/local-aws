POC to spinup `localstack` and `pulumi` - to have testable playground for infrustructure.
There is an integration with `vscode.devcontainer` and `nix` to provide great dev expirience and avoid issues `works for me`.

### Before start 
There are 2 ways of spawning isolated environment for development, one is related to spawning `nix-shell` locally if you are bigger fan of using `terminal`, second one - if there is no ability to have a `root` on machine - to run thru env via `vscode.devcontainer`

#### First way
* install [`nix`](https://nixos.org/download.html)
* install [`direnv`](https://direnv.net/)

#### Second way
* get `vscode` and [`vscode.devcontainer`](https://code.visualstudio.com/docs/remote/remote-overview) extension

### Why
* [`nix`](https://gist.github.com/joepie91/9fdaf8244b0a83afcce204e6da127c7d)
* [`pulumi`](https://www.pulumi.com/docs/intro/vs/terraform/)

### Embeded stack
* [`pulumi`](https://github.com/pulumi/pulumi) - making deployments much simpler, written in beloved language as well as handling [configuration](https://www.pulumi.com/docs/intro/concepts/config/) across any environment with ease.
* [`localstack`](https://github.com/localstack/localstack) - `localstack` is used to provide ability to test things without dependency on internet any any costs.
* [`bazel`](https://bazel.build/)

## Folder structure
I'm following `monorepo` approach so all code lives within one repository.
* `packages` - all packages, `code`, `infra` etc.
* `nix` - environment to be spawned everywhere (`ci`, `local` etc.)
* `.localstack` - local configuration for local `aws` instance
* `.devcontainer` - `vscode` remote environment
* `.pulumi` - [local state](https://www.pulumi.com/docs/intro/concepts/state/) for deployments, similar to `terraform remote` state

## Commands
When spawning `nix-shell` or `remote env` you are gettting some helper commands to hide some implementation details and intrduce more `declarative` approach.

### Environment initialization
* to start all necessary processes for running local environment, go with `start-environment` 

#### Updating `requirements`
* `refresh-deps` - command to update `virtualenv`

#### Localstack
* `start-localstack` - run or update `localstack` instance thru `docker-compose`
* `stop-localstack` - kill `localstack` instance thru `docker-compose`

### AWS
#### when using `aws-cli`
* to create bucket run `create-s3-bucket <your_bucket_name>`, i.e. `create-s3-bucket my-bucket`

#### when using `pulumi`
* to run infra stack run `stack-up <your_project>`, i.e. `stack-up infra/simple_lambda_python`

### Tips and tricks
### Run without spawning a `nix-shell`
It is not required to spawn `nix-shell`, it is possible to run command from `isolated` env like so:
* `nix-shell shell.nix --run 'stack-up packages/infra/simple_lambda_python --yes'`

### Python stack
To make things reusable and managable there are couple of `fp` helpers to make it possible.
* [`functools`](https://docs.python.org/3/library/functools.html)
* [`pampy`](https://github.com/santinic/pampy)

### Building
* `bazel build //infra/simple_lambda_python:main`

### Internals
#### How it works
* `direnv` - when you enter in the directory, direnv will automatically trigger the script inside .envrc.

### To learn
* https://www.youtube.com/watch?v=USDbjmxEZ_I
* https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.section.md
* https://thomazleite.com/posts/development-with-nix-python/
* https://overflowed.dev/blog/how-to-deploy-localstack-with-pulumi/

### TODO
* introduce more meaningful python `requirements` files
* to check https://pypi.org/project/pitfall/