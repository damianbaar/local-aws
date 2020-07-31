let
  pkgs = import ./nix { };

  bootstrap = pkgs.writeScript "bootstrap" ''
    ${pkgs.cowsay}/bin/cowsay "Welcome on my magic meadow"
  '';

  # TODO
  # python -m pip install packages/common/common_types --progress-bar ascii -r packages/common/common_types/requirements.txt
  # stickytape  packages/infra/simple_lambda_python/src/main.py --add-python-path .venv/lib/python3.7/site-packages --add-python-path packages/common
in pkgs.mkShell rec {
  NAME = "playground";
  NIX_SHELL_NAME = "${NAME}#λ";
  PIPENV_IGNORE_VIRTUALENVS = 1;

  venvDir = pkgs.venvDir;

  buildInputs = with pkgs;
    environment.pkgs ++ global-scripts ++ node.pkgs ++ darwin_env.pkgs;

  # INFO: to enable auto-completion in IDE
  postVenvCreation = ''
    unset SOURCE_DATE_EPOCH
    ${pkgs.refresh-deps}/bin/refresh-deps
  '';

  postShellHook = ''
    ${bootstrap}
    unset SOURCE_DATE_EPOCH
  '';
}
