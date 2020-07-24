let
  pkgs = import ./nix { };

  bootstrap = pkgs.writeScript "bootstrap" ''
    ${pkgs.cowsay}/bin/cowsay "Welcome on my magic meadow"
  '';

  start-localstack = pkgs.writeScriptBin "start-local-stack" ''
    ${pkgs.docker-compose}/bin/docker-compose -f .localstack/docker-compose.yml up -d
  '';

  stop-localstack = pkgs.writeScriptBin "stop-local-stack" ''
    ${pkgs.docker-compose}/bin/docker-compose -f .localstack/docker-compose.yml kill
  '';

  create-s3-bucket = pkgs.writeScriptBin "create-s3-bucket" ''
    endpoint=$(${pkgs.jq}/bin/jq '.S3' .localstack/endpoints.json)

    ${pkgs.awscli}/bin/aws \
      --endpoint-url $endpoint \
      s3 mb s3://$1
  ''; 

  refresh-deps = pkgs.writeScriptBin "refresh-deps" ''
    pipenv install -r python-infra-bazel-deps.txt
  '';

  init-infra-local-state = pkgs.writeScriptBin "init-infra-local-state" ''
    pulumi login file://${pkgs.rootFolder}
  '';

  run-stack = pkgs.writeScriptBin "stack-up" ''
    cd $1 && pipenv run pulumi up
  '';

  pythonEnv = pkgs.python37.withPackages (ps: with ps; [
    setuptools
    wheel
    pip
    autopep8
  ]);

  unstable = with pkgs.nixpkgs-unstable.python37Packages; [
    pip
    venvShellHook
  ];

  # TODO create new stack
  local-scripts = [
    start-localstack
    stop-localstack
    create-s3-bucket
    init-infra-local-state
    run-stack
    refresh-deps
  ];

in pkgs.mkShell rec {
  NAME = "playground";
  NIX_SHELL_NAME = "${NAME}#λ";
  PIPENV_IGNORE_VIRTUALENVS=1;

  venvDir = "./.venv";

  buildInputs = with pkgs; unstable ++ local-scripts ++ [
    cowsay
    hello
    bashInteractive
    nixfmt

    nodejs-13_x

    dhall
    dhall-json

    pythonEnv
    python37
    awscli

    pipenv
    pkgs.nixpkgs-unstable.pulumi-bin

    jq

    bazel
    bazel-watcher
    bazel-buildtools
  ];

  # INFO: to enable auto-completion in IDE
  postVenvCreation = ''
    unset SOURCE_DATE_EPOCH
    ${refresh-deps}/bin/refresh-deps
  '';

  postShellHook = ''
    ${bootstrap}
    unset SOURCE_DATE_EPOCH
  '';
}
