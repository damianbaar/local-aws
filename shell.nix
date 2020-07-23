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
    python38Packages.awsume

    python38Packages.simple-python-lambda
    # supervisord
  ];

  postVenvCreation = ''
    unset SOURCE_DATE_EPOCH
    pip install -r requirements.txt
  '';

  shellHook = ''
    ${venv}
    ${bootstrap}
  '';
}
