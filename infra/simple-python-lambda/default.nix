{buildPythonPackage, python38Packages, fetchPypi}:
with python38Packages;
  buildPythonPackage rec {
    pname = "simple-python-lambda";
    version = "0.0.1";
    doCheck = false;
    propagatedBuildInputs = [ pulumi ];
    src = ./.;
  }