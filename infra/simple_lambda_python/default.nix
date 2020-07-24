{buildPythonPackage, python38Packages, fetchPypi}:
with python38Packages;
  buildPythonPackage rec {
    pname = "simple-python-lambda";
    version = "0.0.1";
    checkPhase = ''
      python -m unittest tests/*.py
    '';
    propagatedBuildInputs = [ pulumi ];
    src = ./.;
  }