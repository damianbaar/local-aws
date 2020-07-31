self: super:
let
  latest = super.nixpkgs-unstable;
  nodePackages = latest.nodePackages;
in
{ 
  node = {
    pkgs = with nodePackages; [
      latest.nodejs_latest
      create-react-app
      node-gyp
      swagger
      npm
    ];
  };
}
