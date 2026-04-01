#!/usr/bin/env bash
# .ci/validate-modified.sh ~ a script that does presubmit validation on each new PR

set -eo pipefail

base=${GITHUB_BASE_REF:-master}
wd=${GITHUB_WORKSPACE:-$(pwd)}

echo "===> Working Directory: $wd"

git fetch origin "$base" --depth=1 >/dev/null 2>&1 || true
changed=$(git diff --name-only origin/$base...HEAD \
    | grep '^modules/' \
    | awk -F'/' '{print $2, $3}' \
    | sort -u)

json=$(echo "$changed" | jq -R -s -c '
    split("\n")
    | map(select(length > 0) | split(" "))
    | map({"name": ., "version": .})
')

# Add `modules` and `has_changes` to `$GITHUB_OUTPUT` if we are on GitHub Actions.
if [ -n "$GITHUB_OUTPUT" ]; then
    echo "modules=$json" >> $GITHUB_OUTPUT

    if [ "$json" == "[]" ]; then
        echo "has_changes=false" >> $GITHUB_OUTPUT
    else
        echo "has_changes=true" >> $GITHUB_OUTPUT
    fi
fi

if [ -z "$changed" ]; then
    exit 0
fi

ERROR_LOG="validation_errors.log"
touch "$ERROR_LOG"

failed=0
echo "$changed" | while read -r module version; do
    if [ ! -d "modules/$module/$version" ]; then
        continue
    fi

    echo "===> Validating module \`$module@$version\`"
    tool="$wd/tools/call-bcr-tool"

    if ! "$tool/tools/check_module.py" "$module" "$version" > output.log 2>&1; then
        echo "failed to check module $module@$version:" >> "$ERROR_LOG"
        cat output.log >> "$ERROR_LOG"
        echo -e '\n---\n' >> "$ERROR_LOG"
        FAILED=$((FAILED + 1))
    fi
done

if [ $FAILED -ne 0 ]; then
    exit 1
fi
