let
  pkgs = import ./nix { };

  bootstrap = pkgs.writeScript "bootstrap" ''
    ${pkgs.cowsay}/bin/cowsay "Welcome on my magic meadow"
  '';

  venv = ''
    unset SOURCE_DATE_EPOCH
  '';

in pkgs.mkShell rec {
  NAME = "playground";
  NIX_SHELL_NAME = "${NAME}#λ";
  NIX_CFLAGS_COMPILE = "-I${pkgs.cyrus_sasl}/include/sasl";

  venvDir = ./.venv;

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

    python38Packages.setuptools
    python38Packages.wheel
    python38Packages.localstack
    python38Packages.flask
    python38Packages.pulumi
    python38Packages.pylint
    python38Packages.venvShellHook
    python38Packages.supervisor
    python38Packages.awsume
    python38Packages.moto
    # localstack
    python38Packages.flask_cors
    python38Packages.h11
    python38Packages.quart
    python38Packages.amazon_kclpy
    cyrus_sasl

    python38Packages.simple-python-lambda
    pulumi-bin
  ];

  shellHook = ''
    ${venv}
    ${bootstrap}
  '';
}
