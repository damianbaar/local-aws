load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
http_archive(
    name = "bazel_skylib",
    url = "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.1/bazel-skylib-1.0.1.tar.gz",
    sha256 = "f1c8360c01fcf276778d3519394805dc2a71a64274a3a0908bc9edff7b5aebc8",
)
load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
bazel_skylib_workspace()

# NIX
http_archive(
    name = "io_tweag_rules_nixpkgs",
    strip_prefix = "rules_nixpkgs-0.7.0",
    urls = ["https://github.com/tweag/rules_nixpkgs/archive/v0.7.0.tar.gz"],
    sha256 = "5c80f5ed7b399a857dd04aa81e66efcb012906b268ce607aaf491d8d71f456c8"
)

load("@io_tweag_rules_nixpkgs//nixpkgs:repositories.bzl", "rules_nixpkgs_dependencies")
rules_nixpkgs_dependencies()

load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_local_repository", "nixpkgs_package")

nixpkgs_local_repository(
  name = "nixpkgs", 
  nix_file = "nix/default.nix", 
  nix_file_deps = []
)

# nixpkgs_package(
#   name = "ghc",
#   attribute_path = "haskell.compiler.ghc822",
# )

# PYTHON
http_archive(
    name = "rules_python",
    url = "https://github.com/bazelbuild/rules_python/releases/download/0.0.2/rules_python-0.0.2.tar.gz",
    strip_prefix = "rules_python-0.0.2", 
    sha256 = "b5668cde8bb6e3515057ef465a35ad712214962f0b3a314e551204266c7be90c",
)
load("@rules_python//python:repositories.bzl", "py_repositories")

py_repositories()

# Only needed if using the packaging rules.
load("@rules_python//python:pip.bzl", "pip_repositories", "pip_import")

pip_repositories()

pip_import(
    name = "infra_package_deps",
    requirements = "//:python-infra-bazel-deps.txt",
)

load("@infra_package_deps//:requirements.bzl", _infra_install = "pip_install")
_infra_install()
