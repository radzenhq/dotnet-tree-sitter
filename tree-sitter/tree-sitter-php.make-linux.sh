#!/bin/sh

set -e

cd php
make libtree-sitter-php.so
cp libtree-sitter-php.so ../
