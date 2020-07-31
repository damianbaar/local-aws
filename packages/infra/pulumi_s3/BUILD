load("@rules_python//python:defs.bzl", "py_binary")
load("@infra_package_deps//:requirements.bzl", "requirement")
load("//bazel/python:bundle.bzl", "bundle_python", "generate_bundle_file")

package(default_visibility = ["//visibility:public"])

py_binary(
  name = "main",
  srcs = ["src/main.py"],
  data= [
    ":Pulumi.yaml"
  ],
  deps = [
    requirement("pulumi"),
    requirement("pulumi_aws"),
    requirement("pampy"),
    requirement("boto3")
  ]
)
# stickytape  packages/infra/simple_lambda_python/src/main.py --add-python-path .venv/lib/python3.7/site-packages > packages/infra/simple_lambda_python/__main__.py

generate_bundle_file(
  name = "bundle_infra",
  deps = [
  ]
)
# genrule(
#   name = "run_pulumi",
#   # .executable = 1,
#   srcs = [
#     ":main",
#   ],
#   cmd = " && ".join([
#     "echo $$(realpath $(locations "+ requirement("boto3") + ")) >> $@",
#     "echo $$(realpath $(locations "+ requirement("pampy") + ")) >> $@",
#   ]),
#   outs = [
#     "deps.txt",
#   ],
#   # cmd = "echo 'pulumi up --cwd $(locations :main) "+ requirement("boto3") +")' > $@" 
# )
