let
  pkgs = import ../nix {};
in
  with pkgs;
  {
    inherit bazel;
    inherit python;
  }
