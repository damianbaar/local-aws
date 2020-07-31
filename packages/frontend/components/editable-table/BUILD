# load("//packages/typescript:index.bzl", "ts_devserver", "ts_library")
# load("@build_bazel_rules_typescript//:defs.bzl", "ts_library", "ts_devserver")
# load("//:@bazel/typescript/index.bzl", "ts_library", "ts_devserver")

# ts_library(
#     name = "app",
#     tsconfig = "//:tsconfig.json",
#     srcs = glob(["src/*.ts"])
#     # deps = ["//path/to/other:library"],
#     node_modules = "//:node_modules",
#     compiler = "//:@bazel/typescript/tsc_wrapped"
# )

# ts_devserver(
#     name = "devserver",
#     # We'll collect all the devmode JS sources from these TypeScript libraries
#     deps = [":app"],
#     # This is the path we'll request from the browser, see index.html
#     serving_path = "/bundle.js",
#     # The devserver can serve our static files too
#     static_files = ["index.html"],
# )
