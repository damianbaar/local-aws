{ sources ? import ./sources.nix, system ? null }:
let

  pythonOverlay = (self: super:
    let
      pythonStack = {
        # TODO move it somewhere else - i.e. python_overlay.nix
        packageOverrides = self: super: rec {
          awsume = super.buildPythonApplication rec {
            pname = "awsume";
            version = "4.4.1";
            doCheck = false;
            propagatedBuildInputs = with pkgs.python38Packages; [
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
          flask_cors = super.buildPythonPackage rec {
            pname = "Flask-Cors";
            version = "3.0.8";
            doCheck = false;
            propagatedBuildInputs = with pkgs.python38Packages; [ setuptools six flask ];
            src = super.fetchPypi {
              inherit pname version;
              sha256 = "chcEI+tGEvCEcxiv/4wkezi9UWt3N638ENHCzbs4LRY=";
            };
          };
          hypercorn = super.buildPythonPackage rec {
            pname = "Hypercorn";
            version = "0.10.2";
            doCheck = false;
            propagatedBuildInputs = with pkgs.python38Packages; [ 
              setuptools
              toml
              wsproto
              priority
              typing-extensions
              h2
            ];
            src = super.fetchPypi {
              inherit pname version;
              sha256 = "GfMucmciXIEIrVhbLF3t3x/nWVB5eg6HpoKjoA7xr5U="; 
            };
          };
          quart = super.buildPythonPackage rec {
            pname = "Quart";
            version = "0.13.0";
            doCheck = false;
            propagatedBuildInputs = with pkgs.python38Packages; [ 
              setuptools 
              blinker 
              toml 
              werkzeug 
              hypercorn 
              aiofiles
              jinja2
              click
            ];
            src = super.fetchPypi {
              inherit pname version;
              sha256 = "sqjPDPGwEpzZgezprjBK2XfR3K7JKVIwO9GFJQhxfUQ="; 
            };
          };
          localstack-client = super.buildPythonPackage rec {
            pname = "localstack-client";
            version = "0.24";
            doCheck = false;
            propagatedBuildInputs = [ pkgs.python38Packages.boto3 ];
            src = super.fetchPypi {
              inherit pname version;
              sha256 = "m+Pr5+xx3oTVRKV+gebAMkruoBADKL32Ukg1w/ToeAs=";
            };
          };
          localstack-ext = super.buildPythonPackage rec {
            pname = "localstack-ext";
            version = "0.11.28";
            doCheck = false;
            propagatedBuildInputs = [
              pkgs.python38Packages.requests
              pkgs.python38Packages.dnspython
              pkgs.python38Packages.pyaes
              pkgs.python38Packages.dnslib
            ];
            src = super.fetchPypi {
              inherit pname version;
              sha256 = "m2AL3wFEgT+BxAmCEOS+CM3kPi6BmAkvZ5P4qhdFkes=";
            };
          };

          localstack = super.buildPythonApplication rec {
            pname = "localstack";
            version = "0.11.3";
            doCheck = false;

            NIX_CFLAGS_COMPILE = "-I${pkgs.cyrus_sasl}/include/sasl";
            nativeBuildInputs = [
              pkgs.nodejs-14_x
              pkgs.coreutils
            ];
            propagatedBuildInputs = with pkgs.python38Packages; [
              localstack-client
              localstack-ext
              docopt
              requests
              dnspython
              moto
              flask_cors
              h11
              quart
              amazon_kclpy
            ];
            preBuild = ''
              mkdir -p $out/local-home
              export HOME="$out/local-home"
            '';
            src = super.fetchPypi {
              inherit pname version;
              sha256 = "Zo7wbimlUxLL8ZwQqDlJUe1L41EH+4jVyOAOItHG1JU=";
            };
          };

          pulumi = super.buildPythonPackage rec {
            pname = "pulumi";
            version = "2.7.1";
            doCheck = false;
            propagatedBuildInputs = with pkgs.python38Packages; [ grpcio dill ];
            format = "wheel";
            src = super.fetchPypi {
              inherit pname version;
              format = "wheel";
              sha256 = "4Hyl1OVm5G0iWYDRQs1DeWs0AnlfxNUrmNgWPIrjwGQ=";
            };
          };

          # TODO traverse folder
          simple-python-lambda =
            let app = super.callPackage ../infra/simple-lambda-python { };
            in if pkgs.lib.inNixShell then app.stdenv else app;
        };
      };
    in { python38 = super.python38.override (pythonStack); });

  passthrough = self: super: rec { rootFolder = toString ../.; };

  overlays = [ passthrough pythonOverlay ];

  args = {
    inherit overlays;
  } // {
    inherit overlays;
  } // (if system != null then { inherit system; } else { });

  pkgs = import sources.nixpkgs args;
in pkgs
