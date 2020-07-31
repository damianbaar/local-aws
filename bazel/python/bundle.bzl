load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//lib:shell.bzl", "shell")
load("@rules_python//python:defs.bzl", "py_binary")

### TODO better would be to start from py_binary as it is carrying all necesary libraries

# def _bundle_python(ctx):
#     deps = ctx.attr.deps
#     # deps = deps.map
#     dd = depset(deps)

#     runfiles = ctx.runfiles(files = ctx.files.data)
#     for dep in ctx.attr.deps:
#         print(dep.label)
#         runfiles = runfiles.merge(dep[DefaultInfo].data_runfiles)

#     dup_checker = {}

#     for _d in deps:
#       file = _d[DefaultInfo].files.to_list()
#       for _f in file:
#         if dup_checker.get(_f.dirname) == None:
#           dep_name = _f.dirname.split('/')[0:2]
#           dep_name = "/".join(dep_name)
#           dup_checker.setdefault(dep_name, _f)

#     # ff = ctx.actions.write(
#     #     output = ctx.outputs.bundle_file,
#     #     content = "yo!"
#     # )

#     # fff1 = ctx.actions.declare_file("dupa1") # ctx.outputs.bundle_file)
#     # fff2 = ctx.actions.declare_file("dupa2") # ctx.outputs.bundle_file)

#     # args = ctx.actions.args()
#     # args.add_all("--foo", foo_deps)
#     # args.add_joined("--bar", bar_deps, join_with=",")
#     # args.add("--baz")

#     # native.genrule(
#     #   name = "run_pulumi",
#     #   # .executable = 1,
#     #   srcs = [
#     #   ],
#     #   outs = [
#     #   ],
#     #   cmd = "echo 'pulumi up --cwd' > $@"
#     # )

#     eee = ctx.actions.run_shell(
#         outputs = [ctx.outputs.bundle_file],
#         inputs = [],
#         arguments = [ctx.outputs.bundle_file.path],
#         command = "$(execpath @infra_package_deps_pypi__pulumi_aws_2_13_1//:pkg) > $@",
#         # mnemonic = "GoLink",
#         use_default_shell_env = True,
#     )
#     print(dir(eee))
#   #   return [
#   #   DefaultInfo(
#   #       files = depset([ff]),
#   #       runfiles = ctx.runfiles(collect_default = True),
#   #   ),
#   # ]

#     # ctx.actions.expand_template(
#     #     template = ctx.file.template_file,
#     #     output = ctx.outputs.pom_file,
#     #     substitutions = substitutions,
#     # )

# bundle_python = rule(
#     implementation = _bundle_python,
#     attrs = {
#         "deps": attr.label_list(
#             mandatory = False,
#             aspects = [],
#             providers = [PyInfo]
#         ),
#         "data": attr.label_list(
#             mandatory = False,
#             aspects = [],
#         ),
#     },
#     outputs = {
#       "bundle_file": "%{name}.py",
#       },
# )

def generate_bundle_file(name, deps, tag, deps = [], extraArgs = []):
    py_binary(
        name = "bin",
        srcs = ["src/main.py"],
    )

    # bundle_python(
    #   name = name + "run",
    #   deps = [

    #   ]
    # )

#   native.genrule(
#     """
#     Bundle all packages into one file reusing python_rules repos
#     """
#     name = name,
#     srcs = deps,
#     outs = ["deps.txt"],
#     cmd = deps. " && ".join([
#       "echo $$(realpath $(locations "+ requirement("boto3") + ")) >> $@",
#       "echo $$(realpath $(locations "+ requirement("pampy") + ")) >> $@",
#     ]),
#     executable = False,
#   )

#   genrule(
#     name = "run_pulumi",
#     # .executable = 1,
#     srcs = [
#       ":main",
#       requirement("boto3"),
#       requirement("pampy")
#     ],
#     outs = [
#       "deps.txt",
#     ],
#     # cmd = "echo 'pulumi up --cwd $(locations :main) "+ requirement("boto3") +")' > $@"
#   )
