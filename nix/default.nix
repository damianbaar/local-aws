{ sources ? import ./sources.nix
, system ? null
}:
let
  passthrough = self: super: rec {
    rootFolder = toString ../.;

    customPython = pkgs.python38.buildEnv.override {
      extraLibs = [ pkgs.python38Packages.ipython ];
    };
  };

  overlays = [
    passthrough
  ];

  args = { } // {
    inherit overlays;
  } // (if system != null then { inherit system; } else { });

  pkgs = import sources.nixpkgs args;
in pkgs
