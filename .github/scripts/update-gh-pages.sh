#!/bin/bash

# This script updates `index.md` in the GitHub Pages root directory provided
# by the required argument to be passed. The file will be updated with
# the JSON data in `gh-pages-data`. `index.md` is the file served by
# GitHub Pages after being built by Jekyll and the Markdown processed by kramdown.

gh_pages_root_dir="$1"
if [ -z "$gh_pages_root_dir" ]; then
  echo "Error: The path to the GitHub Pages root directory must be passed"
  exit 1
fi

dir1_data="$gh_pages_root_dir/gh-pages-data/dir1/data.json"
dir2a_data="$gh_pages_root_dir/gh-pages-data/dir2/dir2a/data.json"
dir2b_data="$gh_pages_root_dir/gh-pages-data/dir2/dir2b/data.json"

data_files=("$dir1_data" "$dir2a_data" "$dir2b_data")

for file in "${data_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Error: File does not exist - $file"
        exit 1
    fi
done

# Render builds as a markdown table with clickable links.
render_builds_table() {
    local build_info_file="$1"
    if [ -z "$build_info_file" ]; then
        echo "Error: A file path argument is required"
        return 1
    fi

    # Sort builds by version descending and render as markdown table.
    jq -r '
        .builds | sort_by(.version) | reverse |
        ["| Release | Dep. Versions | SHA256 |", "|---------|---------------|--------|"] +
        [.[] |
            "| [\(.name) \(.longVersion)](\(.url)) | \(.depFirstSupportedVersion) - \(.depLastSupportedVersion) | `\(.sha256[0:16])...` |"
        ] | .[]
    ' "$build_info_file"
}

echo "Updating GitHub Pages index.md file..."

cat > "$gh_pages_root_dir/index.md" << EOF
---
title: GitHub Pages Test Page
---

# GitHub Pages Test Page
{:.no_toc}

Details are shown here. The information is synced with the [workflow-tests GitHub repository](https://github.com/elle-j/workflow-tests).

## Contents
* TOC
{:toc}

## Dir1

$(render_builds_table $dir1_data)

[Full JSON](https://elle-j.github.io/workflow-tests/gh-pages-data/dir1/data.json)

## Dir2

### Dir2a

$(render_builds_table $dir2a_data)

[Full JSON](https://elle-j.github.io/workflow-tests/gh-pages-data/dir2/dir2a/data.json)

### Dir2b

$(render_builds_table $dir2b_data)

[Full JSON](https://elle-j.github.io/workflow-tests/gh-pages-data/dir2/dir2b/data.json)
EOF

echo "File has been updated!"
