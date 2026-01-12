#!/bin/bash

# This script updates `index.md` in the GitHub Pages root directory provided
# by the required argument to be passed. The file will be updated with
# the JSON data in `gh-pages-data`. `index.md` is the file served by
# GitHub Pages after being built by Jekyll and the Markdown processed by kramdown.

if [ $# -eq 0 ]; then
  echo "Error: The path to the GitHub Pages root directory must be passed"
  exit 1
fi

gh_pages_root_dir="$1"

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

# Sort the data by version in descending order.
sort_by_version_descending() {
    local data_file="$1"
    if [ -z "$data_file" ]; then
        echo "Error: A data file argument is required for sorting"
        return 1
    fi

    # Load the data and sort builds and releases with the latest version first.
    data=$(jq '.' "$data_file")
    sorted_data=$(echo "$data" | jq '.builds = (.builds | sort_by(.version) | reverse) |
                                     .releases = (.releases | to_entries | sort_by(.key) | reverse | from_entries)')

    echo "$sorted_data"
}

echo "Updating GitHub Pages index.md file..."

cat > "$gh_pages_root_dir/index.md" << EOF
---
title: GitHub Pages Test Page
---

# GitHub Pages Test Page

Details are shown here. The information is synced with the [workflow-tests GitHub repository](https://github.com/elle-j/workflow-tests).

## Dir1

<details>
    <summary>See info</summary>

{% highlight json %}
$(sort_by_version_descending $dir1_data)
{% endhighlight %}

</details>

## Dir2

### Dir2a

<details>
    <summary>See info</summary>

{% highlight json %}
$(sort_by_version_descending $dir2a_data)
{% endhighlight %}

</details>

### Dir2b

<details>
    <summary>See info</summary>

{% highlight json %}
$(sort_by_version_descending $dir2b_data)
{% endhighlight %}

</details>
EOF

echo "File has been updated!"
