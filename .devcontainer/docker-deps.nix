let
  pkgs = import ../nix {};
in
  with pkgs;
  environment.pkgs ++ global-scripts
