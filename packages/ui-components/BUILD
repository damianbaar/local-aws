package(default_visibility = ["//visibility:public"])
load("@npm//@bazel/typescript:index.bzl","ts_config", "ts_library")
load("@build_bazel_rules_nodejs//:index.bzl", "pkg_npm")

# ts_config(
#     name = "tsconfig",
#     src = "",
#     deps = [":tsconfig.json"],
# )

ts_library(
    name = "lib",
    srcs = glob(["*.tsx"]),
    tsconfig = "//:tsconfig.json",
    module_name = "@root/ui-components",
    deps = [
      "@npm//react",
      "@npm//@types",
      "@npm//@types/react",
    ],
)

