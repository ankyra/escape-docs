#!/bin/bash -e

rm -rf content/docs
mkdir -p content/
cp -r deps/_/escape-client/docs/cmd content/docs

for x in content/docs/*.md ; do 
    content=$(cat $x| sed 's|(\(.*\)\.md)|(../\1/)|g')
    title=$(head -1 < $x | sed 's/#//g')
    slug=$(basename $x)
    read -d '' header <<EOF || true
+++
summary = ""
title = "$title"
slug = "${slug/.md}"
type = "docs"
+++

EOF
    echo -e "$header\n$content" > $x
done

hugulp build
