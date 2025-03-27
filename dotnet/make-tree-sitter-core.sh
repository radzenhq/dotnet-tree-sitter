#!/bin/sh

cd `dirname "$0"`

dotnet build -property:VERSION_POSTFIX=".$1" TreeSitter/TreeSitter.csproj

mkdir -p out
cp TreeSitter/bin/Debug/TreeSitter.NET.*.nupkg out/
