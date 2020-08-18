load("@build_bazel_rules_nodejs//:index.bzl", "pkg_web")
load("@npm//@babel/cli:index.bzl", "babel")
load("@npm//@bazel/rollup:index.bzl", "rollup_bundle")
load("@npm//@bazel/terser:index.bzl", "terser_minified")
load("@npm//@bazel/typescript:index.bzl", "ts_library")

def differential_loading(name, entry_point, srcs, deps = [], public = []):
    "Common workflow to serve TypeScript to modern browsers"

    ts_library(
        name = name + "_lib",
        deps = deps,
        srcs = srcs,
    )

    rollup_bundle(
        name = name + "_chunks",
        deps = [name + "_lib"] + [
          "@npm//@rollup/plugin-replace",
          "@npm//@rollup/plugin-commonjs",
          "@npm//@rollup/plugin-node-resolve",
        ],
        sourcemap = "inline",
        config_file = "//:rollup.config.js",
        entry_points = {
            entry_point: "index",
        },
        output_dir = True,
    )

    # For older browsers, we'll transform the output chunks to es5 + systemjs loader
    babel(
        name = name + "_chunks_es5",
        data = [
            name + "_chunks",
            "//:es5.babelrc",
            "@npm//@babel/preset-env",
        ],
        output_dir = True,
        args = [
            "$(execpath %s_chunks)" % name,
            "--config-file",
            "$(execpath //:es5.babelrc)",
            "--out-dir",
            "$(@D)",
        ],
    )

    # Run terser against both modern and legacy browser chunks
    terser_minified(
        name = name + "_chunks_es5.min",
        src = name + "_chunks_es5",
    )

    terser_minified(
        name = name + "_chunks.min",
        src = name + "_chunks",
    )

    pkg_web(
        name = name,
        srcs = [
            name + "_chunks.min",
            name + "_chunks_es5.min",
        ] + public,
    )
