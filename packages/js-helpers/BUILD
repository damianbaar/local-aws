package(default_visibility = ["//visibility:public"])

load("@npm//@bazel/typescript:index.bzl", "ts_library")

filegroup(
    name = "sources",
    srcs = glob(["*.ts"]),
)

ts_library(
    name = "lib",
    tsconfig = "//:tsconfig.json",
    module_name = "@root/js-helpers",
    srcs = [":sources"]
)

# sources
# filegroup(
#     name = "another_lib.js",
#     srcs = ["//packages/another_lib:lib"],
#     # output_group = "es5_sources",
# )
