#!/usr/bin/env bash
set -e

if ! command -v bazel >/dev/null; then
    echo "fatal: cannot find \`bazel\`"
fi

wd=${GITHUB_WORKSPACE:-$(pwd)}
module="$1"
version="$2"

if [ -z "$module" ]; then
    echo "fatal: missing first argument: <MODULE>"
    exit 1
fi

if [ -z "$version" ]; then
    echo "fatal: missing second argument: <VERSION>"
    exit 1
fi

scratchdir=$(mktemp -d)
cd "$scratchdir"

cat <<EOF > MODULE.bazel
module(name = "module_test")
bazel_dep(name = "$module", version = "$version")
EOF

echo "==> trigger: \`bazel fetch\`"
bazel fetch --registry=https://bcr.bazel.build --registry="file://$wd" >/dev/null || exit 1

echo "==> trigger: \`bazel mod graph\`"
bazel mod resolve --registry=https://bcr.bazel.build --registry="file://$wd" --extension_info=all >/dev/null || exit 1
