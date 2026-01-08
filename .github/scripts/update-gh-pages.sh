#!/bin/bash

# This script updates `index.md` in the directory provided by the required
# `GH_PAGES_ROOT_DIR` environment variable. The file will be updated
# with the JSON data in `gh-pages-data`. `index.md` is the file served
# by GitHub Pages after being processed by Jekyll.

if [ -z "$GH_PAGES_ROOT_DIR" ]; then
    echo "Error: GH_PAGES_ROOT_DIR environment variable is not set."
    exit 1
fi

dir1_data="$GH_PAGES_ROOT_DIR/gh-pages-data/dir1/data.json"
dir2a_data="$GH_PAGES_ROOT_DIR/gh-pages-data/dir2/dir2a/data.json"
dir2b_data="$GH_PAGES_ROOT_DIR/gh-pages-data/dir2/dir2b/data.json"

data_files=("$dir1_data" "$dir2a_data" "$dir2b_data")

for file in "${data_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Error: File does not exist - $file"
        exit 1
    fi
done

echo "Updating GitHub Pages index.md file..."

cat > "$GH_PAGES_ROOT_DIR/index.md" << EOF
---
title: GitHub Pages Test Page
---

# GitHub Pages Test Page
{:.no_toc}

## Data
* TOC
{:toc}

## Dir1

\`\`\`json
$(cat $dir1_data)
\`\`\`

## Dir2

### Dir2a

\`\`\`json
$(cat $dir2a_data)
\`\`\`

### Dir2b

\`\`\`json
$(cat $dir2b_data)
\`\`\`
EOF

echo "File has been updated!"
