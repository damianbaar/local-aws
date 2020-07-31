def upload_docker_image(name, target, tag, deps = [], extraArgs = []):
    native.sh_test(
        name = name,
        data = [target] if target != "" else [],
        deps = deps,
        args = [("$(location " + target + ")"), tag] + extraArgs,
        srcs = ["//bazel:upload_docker_image.sh"],
        tags = ["manual"],
    )
