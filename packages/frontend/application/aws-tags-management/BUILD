load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@build_bazel_rules_nodejs//:index.bzl", "copy_to_bin", "nodejs_test")
load("@npm//react-scripts:index.bzl", "react_scripts", "react_scripts_test")

# alias(
#     name = "tsconfig.json",
#     actual = "//:tsconfig.json",
# )

_TESTS = [
    "src/**/*.test.js*",
    "src/**/*.test.ts*",
    "src/**/*.spec.js*",
    "src/**/*.spec.ts*",
    "src/**/__tests__/**/*.js*",
    "src/**/__tests__/**/*.ts*",
]

copy_to_bin(
    name = "copy_static_files",
    srcs = glob(
        [
            "public/*",
            "src/**/*",
        ],
        exclude = _TESTS,
    ) + [
        "package.json",
        # "tsconfig.json"
        # "//:tsconfig.json",
        # "//:package.json"
    ]
)

# react-scripts can only work if the working directory is the root of the application.
# So we'll need to chdir before it runs.
write_file(
    name = "write_chdir_script",
    out = "chdir.js",
    content = ["process.chdir(__dirname)"],
)

_RUNTIME_DEPS = [
    "chdir.js",
    "copy_static_files",
    "@npm//react",
    "@npm//react-dom",
]

react_scripts(
    # Note: this must be named "build" since react-scripts hard-codes that as the output dir
    name = "build",
    args = [
        "--node_options=--require=./$(execpath chdir.js)",
        "build",
    ],
    data = _RUNTIME_DEPS + [
        "@npm//@types",
    ],
    output_dir = True,
)

react_scripts(
    name = "run",
    args = [
        "--node_options=--require=./$(rootpath chdir.js)",
        "start",
    ],
    data = _RUNTIME_DEPS,
)
