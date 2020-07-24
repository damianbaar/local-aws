let
  pkgs = import ./nix { };

  bootstrap = pkgs.writeScript "bootstrap" ''
    ${pkgs.cowsay}/bin/cowsay "Welcome on my magic meadow"
  '';

  start-localstack = pkgs.writeScriptBin "start-local-stack" ''
    MAIN_CONTAINER_NAME=dupa LOCALSTACK_DOCKER_NAME=dupa USE_LIGHT_IMAGE=0 ENTRYPOINT=-d ${pkgs.python38Packages.localstack}/bin/localstack start --docker
  '';

  stop-localstack = pkgs.writeScriptBin "stop-local-stack" ''
    ${pkgs.docker}/bin/docker stop localstack_main
  '';

in pkgs.mkShell rec {
  NAME = "playground";
  NIX_SHELL_NAME = "${NAME}#λ";
  NIX_CFLAGS_COMPILE = "-I${pkgs.cyrus_sasl}/include/sasl";

  venvDir = "./.venv";

  buildInputs = with pkgs; [
    cowsay
    hello
    bashInteractive
    nixfmt

    nodejs-14_x
    awscli

    dhall
    dhall-json
    python38
    python38Packages.pip
    python38Packages.venvShellHook
    python38Packages.setuptools
    python38Packages.wheel
    python38Packages.psutil
    python38Packages.localstack
    # python38Packages.flask
    # python38Packages.pulumi
    # python38Packages.pylint
    # python38Packages.supervisor
    # python38Packages.awsume
    # localstack
    # python38Packages.moto
    # python38Packages.flask_cors
    # python38Packages.h11
    # python38Packages.quart
    # python38Packages.amazon_kclpy
    cyrus_sasl

    python38Packages.simple-python-lambda
    pulumi-bin

    start-localstack
    stop-localstack

    jq
  ];

  postVenvCreation = ''
    unset SOURCE_DATE_EPOCH
    pip install -r requirements.txt

    ${bootstrap}
  '';

  postShellHook = ''
    unset SOURCE_DATE_EPOCH
  '';
}
