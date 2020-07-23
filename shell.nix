let
  pkgs = import ./nix { };

  bootstrap = pkgs.writeScript "bootstrap" ''
    ${pkgs.cowsay}/bin/cowsay "Welcome on my magic meadow"
  '';

  venv = ''
    alias pip="PIP_PREFIX='$(pwd)/_build/pip_packages' \pip"
    export PYTHONPATH="$(pwd)/_build/pip_packages/lib/python3.8/site-packages:$PYTHONPATH"
    unset SOURCE_DATE_EPOCH
  '';

in pkgs.mkShell rec {
  NAME = "playground";
  NIX_SHELL_NAME = "${NAME}#λ";

  buildInputs = with pkgs; [
    cowsay
    hello
    bashInteractive
    nixfmt

    dhall
    dhall-json
    python38
    python38Packages.pip

    python38Packages.setuptools
    python38Packages.wheel
    python38Packages.localstack
    python38Packages.flask
    python38Packages.pulumi
    # python38Packages.flask_swagger

    pulumi-bin
  ];

  shellHook = ''
    ${venv}
    ${bootstrap}
  '';
}
