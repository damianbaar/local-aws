self: super: 
with super;
let
  # TODO create pulumi new stack
  # TODO create pulumi config set aws:region

  start-localstack = pkgs.writeScriptBin "start-local-stack" ''
    ${pkgs.docker-compose}/bin/docker-compose \
      -f ${pkgs.rootFolder}/.localstack/docker-compose.yml up -d
  '';

  stop-localstack = pkgs.writeScriptBin "stop-local-stack" ''
    ${pkgs.docker-compose}/bin/docker-compose \
      -f ${pkgs.rootFolder}/.localstack/docker-compose.yml kill
  '';

  create-s3-bucket = pkgs.writeScriptBin "create-s3-bucket" ''
    endpoint=$(${pkgs.jq}/bin/jq '.S3' ${pkgs.rootFolder}/.localstack/endpoints.json | tr -d '"')

    ${pkgs.awscli}/bin/aws \
      --endpoint-url $endpoint \
      s3 mb s3://$1
  '';

  refresh-deps = pkgs.writeScriptBin "refresh-deps" ''
    ${pkgs.pipenv}/bin/pipenv install -r python-infra-bazel-deps.txt
  '';

  init-infra-local-state = pkgs.writeScriptBin "init-infra-local-state" ''
    ${pkgs.nixpkgs-unstable.pulumi-bin}/bin/pulumi login file://${pkgs.rootFolder}
  '';

  run-stack = pkgs.writeScriptBin "stack-up" ''
    ${build-infra-artifact}/bin/build-infra-artifact $1
    ${pkgs.pulumi-latest}/bin/pulumi up --cwd $*
  '';

  run-pulumi = pkgs.writeScriptBin "deployer" ''
    ${pkgs.pipenv}/bin/pipenv run pulumi $1 --cwd $2
  '';

  start = pkgs.writeScriptBin "start-environment" ''
    ${init-infra-local-state}/bin/init-infra-local-state
    ${start-localstack}/bin/start-local-stack
  '';

  get-endpoint = pkgs.writeScriptBin "getEndpoint" ''
    cat $ROOT_FOLDER/.localstack/endpoints.json | jq .$1 | tr -d '"'
  '';

  build-infra-artifact = pkgs.writeScriptBin "build-infra-artifact" ''
    mkdir -p $1/dist
    ${pkgs.python37Packages.stickytape}/bin/stickytape $1/src/main.py > $1/dist/bundle.py
  '';
in {
  inherit refresh-deps;

  global-scripts = [
    start
    run-pulumi
    start-localstack
    stop-localstack
    create-s3-bucket
    init-infra-local-state
    run-stack
    refresh-deps
    build-infra-artifact
    get-endpoint
  ];
}