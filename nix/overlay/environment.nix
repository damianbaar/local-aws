self: super:
let
  pythonEnv = super.python37.withPackages
    (ps: with ps; [ setuptools wheel autopep8 stickytape pylint ]);

  unstable = with super.nixpkgs-unstable.python37Packages; [ pip venvShellHook ];
in
{ 
  environment = {
    pkgs = with super; [
      cowsay
      hello
      bashInteractive
      nixfmt
      dhall
      dhall-json
      pythonEnv
      super.python37Packages.stickytape
      python37
      awscli
      pipenv
      pulumi-latest
      jq
      bazel
      bazel-watcher
      bazel-buildtools
    ] ++ unstable;
  };
}
