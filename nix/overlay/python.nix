self: super:
let
  pythonStack = {
    # TODO move it somewhere else - i.e. python_overlay.nix
    packageOverrides = self: super: rec {
      awsume = super.buildPythonApplication rec {
        pname = "awsume";
        version = "4.4.1";
        doCheck = false;
        propagatedBuildInputs = with self.python37Packages; [
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

      stickytape = super.buildPythonApplication rec {
        pname = "stickytape";
        version = "0.1.14";
        doCheck = false;
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "W2Gd1m1CY1k1oHDUDRGQoaMnqTNAUcc7wW0SFGjx7nI=";
        };
      };
    };
  };
in { python37 = super.python37.override (pythonStack); }
