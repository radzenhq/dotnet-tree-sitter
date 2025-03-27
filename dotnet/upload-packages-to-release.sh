#!/bin/sh

cd `dirname $0`

url=`echo "$1" | sed -re 's|assets.*$|assets|'`

cd out

for pkg in *.nupkg
do
  echo Uploading $pkg to release "$url"

  curl -L \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "Content-Type: application/zip" \
    "$url?name=$pkg" \
    --data-binary "@$pkg"

done