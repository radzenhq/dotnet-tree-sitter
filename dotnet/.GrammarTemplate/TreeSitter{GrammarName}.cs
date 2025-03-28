using System;
using System.Runtime.InteropServices;

namespace TreeSitter;

public static class {GrammarName}
{
    public static Language CreateLanguage() => new {GrammarName}Language();

    private class {GrammarName}Language() : Language(tree_sitter_{grammar_name}())
    {
    }
    [DllImport("tree-sitter-{grammar-name}", CallingConvention = CallingConvention.Cdecl)]
    private static extern IntPtr tree_sitter_{grammar_name}();
}

