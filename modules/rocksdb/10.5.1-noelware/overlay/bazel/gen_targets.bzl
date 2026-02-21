# This is from the `rocksdb` derivation from BCR.
# -----------------------------------------------
# Source: https://github.com/bazelbuild/bazel-central-registry/blob/aeb0f3ee77d068a785335a0fa00cecb8b7c79b50/modules/rocksdb/9.11.2/overlay/gen_test_targets.bzl
# License SPDX: Apache-2.0

load("@rules_cc//cc:defs.bzl", "cc_test")

def gen_cc_tests(srcs):
    """Generates a cc_test target for each source file.

    Args:
      srcs: test files to generate cc_test targets for
    """

    for src in srcs:
        name = src.removesuffix(".cc").replace("/", "_")
        cc_test(
            name = name,
            srcs = [src],
            deps = [":test_lib"],
            linkopts = ["-ldl"],  # for Debian
            timeout = "long",
        )
