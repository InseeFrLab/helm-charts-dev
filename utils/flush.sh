#!/bin/bash

# Ensure correct usage
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 '<chart_name>'"
    exit 1
fi

CHART_NAME="$1"

# Deleting the chart from current branch
CHART_FILE=$(grep -Er "^ *name *: *$CHART_NAME *$" charts/ --include=Chart.yaml)
if [[ -n "$CHART_FILE" ]]; then
    CHART_PATH=$(echo "$CHART_FILE" | awk -F':' '{print $1}' | xargs -n1 dirname)
    if [[ -n "$CHART_PATH" ]]; then
        echo "rm -r \"$CHART_PATH\""
        echo "git add \"$CHART_PATH\""
        echo "git commit -m \"[$CHART_NAME] Flushing chart\""
        echo "git push"
    fi
fi

# Retrieve the helm repo index.yaml
INDEX_URL=$(gh repo view --json owner,name -q '"https://" + .owner.login + ".github.io/" + .name + "/index.yaml"')
rm -rf /tmp/index.yaml
wget "$INDEX_URL" -q -P /tmp/

# List all tags from helm repo and delete them from Github
TAGS=$(yq '.entries | to_entries | .[] | select(.key == "'"$CHART_NAME"'") | .key as $chart | .value[].version | "\($chart)-\(.)"' /tmp/index.yaml)
# Iterate over the list
for TAG in $TAGS; do
    gh release view $TAG > /dev/null 2>&1 && echo "gh release delete $TAG -y"
done

# Commands
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "git checkout gh-pages"
echo "git pull"
echo "yq -i 'del(.entries[\"$CHART_NAME\"])' index.yaml"
echo "git commit -m \"[$CHART_NAME] Flushing chart from helm repo\""
echo "git push"
echo "git checkout $CURRENT_BRANCH"

# Clean up
rm -rf /tmp/index.yaml
