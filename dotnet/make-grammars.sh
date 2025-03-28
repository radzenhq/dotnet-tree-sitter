#!/bin/sh

set -e

cd `dirname "$0"`

grammars=`ls -d ../native/tree-sitter-*/ -1 | sed 's|../native/tree-sitter-||' | sed s'|/||'`

mkdir -p out

for grammar in $grammars
do
    echo
    echo
    echo Making binding for grammar $grammar

    camel=`echo "$grammar" | sed -r 's/-([a-z])/\U\1/gi' | sed -r 's/^([a-z])/\U\1/'`
    dashed=$grammar
    underscored=`echo "$grammar" | sed 's|-|_|'g`

    cd .GrammarTemplate

    for f in `find -type f,l`
    do
        dstPath="../TreeSitter$camel"/`echo $f | sed "s|{GrammarName}|$camel|g" | sed "s|{grammar_name}|$underscored|g" | sed "s|{grammar-name}|$dashed|g"`
        mkdir -p `dirname "$dstPath"`

        echo $f "->" $dstPath

        [ -f "$f" ] && cat $f | sed "s|{GrammarName}|$camel|g" | sed "s|{grammar_name}|$underscored|g" | sed "s|{grammar-name}|$dashed|g" > "$dstPath"
        [ -L "$f" ] && cp --preserve=links -r "$f" "$dstPath"

    done

    cd ..

    dotnet build -property:VERSION_POSTFIX=".$1" "TreeSitter$camel"/*.csproj
    cp "TreeSitter$camel"/bin/Debug/*.nupkg out/
done