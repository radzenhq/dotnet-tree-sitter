#!/bin/sh

set -e

echo Making on MACOS

cd `dirname "$0"`

outdir="out/$1"

cd tree-sitter
make libtree-sitter.dylib

cd ..

mkdir -p "$outdir"
cp tree-sitter/libtree-sitter.dylib "$outdir/"

for grammar in `ls -d tree-sitter-*/ -1 | sed 's|tree-sitter-||' | sed s'|/||'`
do
    echo
    echo
    echo Making grammar $grammar on MACOS

    cd tree-sitter-$grammar

    if [ -x ../tree-sitter-$grammar.make-macos.sh ]
    then
        ../tree-sitter-$grammar.make-macos.sh
    else
        make libtree-sitter-$grammar.dylib
    fi

    cd ..
    cp tree-sitter-$grammar/libtree-sitter-$grammar.dylib "$outdir/"
done
