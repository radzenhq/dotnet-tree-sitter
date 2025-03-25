#!/bin/sh

set -e

cd php
make libtree-sitter-php.dylib
cp libtree-sitter-php.dylib ../
