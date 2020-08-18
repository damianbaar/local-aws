load("@npm//@bazel/protractor:index.bzl", "protractor_web_test_suite")
load("@npm//http-server:index.bzl", "http_server")
load("@npm//mocha:index.bzl", "mocha_test")
load("//tools/bazel/js:differential_loading.bzl", "differential_loading")
load("@npm//@bazel/typescript:index.bzl", "ts_library")

ts_library(
    name = "app_lib_test",
    srcs = glob(["*.ts"]),
    tsconfig = "//:tsconfig.json",
    deps = [
        "//packages/js-helpers:lib",
        "//packages/ui-components:lib",
    ],
)

differential_loading(
    name = "app",
    srcs = glob(["*.ts"]),
    entry_point = "index.ts",
    public = [
      ":favicon.png",
      ":index.html",
    ],
    deps = [
        "//packages/js-helpers:lib",
        "//packages/ui-components:lib",
    ],
)

http_server(
    name = "server",
    data = [":app"],
    templated_args = ["../$(location :app)"], # workspace is not necessary here
)

protractor_web_test_suite(
    name = "server_test",
    srcs = ["app.spec.js"],
    on_prepare = ":protractor.on-prepare.js",
    server = ":server",
)
