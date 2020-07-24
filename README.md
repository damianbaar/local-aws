POC to spinup `localstack` and some deployment tools (i.e. `aws-cdk`) - to have testable playground for infrustructure.

### Before start 
#### Prerequisites
* install [`nix`](https://nixos.org/download.html)
* install [`direnv`](https://direnv.net/)

### Why
* [`nix`](https://gist.github.com/joepie91/9fdaf8244b0a83afcce204e6da127c7d)

### Startup
`localstack` is used to provide ability to test things without dependency on internet any any costs.
> you can find couple of helpers to manage the local environment, this is, `start-localstack` & `stop-localstack`

#### What you will get
* [`pulumi`](https://github.com/pulumi/pulumi)
* [`localstack`](https://github.com/localstack/localstack)

#### How it works
When you enter in the directory, direnv will automatically trigger the script inside .envrc.

### To learn
* https://www.youtube.com/watch?v=USDbjmxEZ_I
* https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.section.md
* https://thomazleite.com/posts/development-with-nix-python/
* https://overflowed.dev/blog/how-to-deploy-localstack-with-pulumi/
