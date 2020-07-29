{ sources ? import ./sources.nix, system ? null }:
let

  passthrough = self: super: rec { 
    rootFolder = toString ../.; 
    nixpkgs-unstable = import sources.nixpkgs-unstable {};
  };

  overlays = [ 
    passthrough 
    (import ./overlay/python.nix)
    (import ./tools/overlay.nix)
    (import ./overlay/environment.nix)
    (import ./overlay/global-scripts.nix)
  ];

  args = {
    inherit overlays;
  } // (if system != null then { inherit system; } else { });

  pkgs = import sources.nixpkgs args;
in pkgs
