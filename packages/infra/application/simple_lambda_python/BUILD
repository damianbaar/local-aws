load("@rules_python//python:defs.bzl", "py_binary")
load("@infra_package_deps//:requirements.bzl", "requirement")

package(default_visibility = ["//visibility:public"])

py_binary(
  name = "main",
  srcs = glob(["src/*.py"]),
  deps = [
    requirement("pulumi"),
    requirement("pulumi_aws"),
    requirement("pampy"),
    requirement("boto3")
  ]
)
