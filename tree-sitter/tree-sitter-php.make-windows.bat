@echo off

cd php

del Makefile
copy ..\..\Makefile.windows.tree-sitter-grammar Makefile
nmake tree-sitter-php.dll GRAMMAR=php

cd ..
copy php\tree-sitter-php.dll .

