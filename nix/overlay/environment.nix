self: super:
let
  pythonEnv = super.python37.withPackages
    (ps: with ps; [ setuptools wheel pip autopep8 stickytape pylint ]);

  unstable = with super.nixpkgs-unstable.python37Packages; [ pip venvShellHook ];
in
{ 
  environment = {
    pkgs = with super; [
      cowsay
      hello
      bashInteractive
      nixfmt
      nodejs-13_x
      dhall
      dhall-json
      pythonEnv
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
