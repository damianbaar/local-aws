self: super:
let
  pythonStack = {
    # TODO move it somewhere else - i.e. python_overlay.nix
    packageOverrides = self: super: rec {
      awsume = super.buildPythonApplication rec {
        pname = "awsume";
        version = "4.4.1";
        doCheck = false;
        propagatedBuildInputs = with self.python38Packages; [
          setuptools
          pyyaml
          pluggy
          colorama
          boto3
          psutil
        ];
        preBuild = ''
          mkdir -p $out/.home
          export HOME="$out/.home"
          touch $out/.home/.bash_profile
        '';
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "wSuVxeVfZjwhgk964jO7xB/6QYoAT3ORmDUBRBjaHW0=";
        };
      };
    };
  };
in { python38 = super.python38.override (pythonStack); }
