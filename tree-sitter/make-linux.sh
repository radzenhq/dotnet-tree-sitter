#!/bin/sh

set -e

echo Making on LINUX

cd tree-sitter/tree-sitter
make libtree-sitter.so

cd ..

mkdir out
cp tree-sitter/libtree-sitter.so out/

for grammar in `ls -d tree-sitter-*/ -1 | sed 's|tree-sitter-||' | sed s'|/||'`
do
    echo
    echo
    echo Making grammar $grammar on LINUX

    cd tree-sitter-$grammar

    if [ -x ../tree-sitter-$grammar.make-linux.sh ]
    then
        ../tree-sitter-$grammar.make-linux.sh
    else
        make libtree-sitter-$grammar.so
    fi

    cd ..
    cp tree-sitter-$grammar/libtree-sitter-$grammar.so out/
done
