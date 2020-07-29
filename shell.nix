let
  pkgs = import ./nix { };

  bootstrap = pkgs.writeScript "bootstrap" ''
    ${pkgs.cowsay}/bin/cowsay "Welcome on my magic meadow"
  '';

in pkgs.mkShell rec {
  NAME = "playground";
  NIX_SHELL_NAME = "${NAME}#λ";
  PIPENV_IGNORE_VIRTUALENVS = 1;

  venvDir = "./.venv";

  buildInputs = with pkgs; environment.pkgs ++ global-scripts;

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
