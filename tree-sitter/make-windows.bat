@echo on & setlocal EnableDelayedExpansion

echo Making on WINDOWS
call "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\VsDevCmd.bat"

cd tree-sitter/tree-sitter

del Makefile
copy ..\Makefile.windows.tree-sitter Makefile

nmake tree-sitter.dll

cd ..

mkdir out
copy tree-sitter\tree-sitter.dll out\

for /d %%d in (tree-sitter-*) do (
    set "grammar=%%d"
    set "grammar=!grammar:tree-sitter-=!"
    echo.
    echo.
    echo Making grammar !grammar! on WINDOWS

    cd tree-sitter-!grammar!

    if exist "..\tree-sitter-!grammar!.make-windows.bat" (
        call "..\tree-sitter-!grammar!.make-windows.bat"
    ) else (
        del Makefile
        copy ..\Makefile.windows.tree-sitter-grammar Makefile
        echo. >> src\scanner.c
        nmake tree-sitter-!grammar!.dll GRAMMAR=!grammar!
    )

    cd ..
    copy tree-sitter-!grammar!\tree-sitter-!grammar!.dll out\
)