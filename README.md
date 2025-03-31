It's a refactored .NET binding for https://github.com/tree-sitter/tree-sitter library. I've tried to hide pointers and make usage more comfortable.

Sample code:


```
using TreeSitter;
using Newtonsoft.Json;

class Program
{
    static void Main(string[] args)
    {
        var lang = Python.CreateLanguage();
        var parser = new Parser(lang);
        var source = File.ReadAllText("source.py", Encoding.UTF8);

        using var tree = parser.ParseString(source);

        using (var query = new Query(lang, "(import_statement) @import"))
        {
            foreach (var node in query.Captures(tree.RootNode()).Select(x => x.Node))
            {
                var moduleName = node.ChildByFieldName("name").Text(source);
                var match = new
                {
                    type = "import",
                    module = moduleName,
                    start = new { row = node.StartPoint().Row, col = node.StartPoint().Column },
                    end = new { row = node.EndPoint().Row, col = node.EndPoint().Column },
                    text = node.Text(source)
                };

                Console.WriteLine(JsonConvert.SerializeObject(match));
            }
        }
    }
}
```

Binding for the grammar can be created using native grammar library and code like this:

```
using System;
using System.Runtime.InteropServices;

namespace TreeSitter;

public static class Python
{
    public static Language CreateLanguage() => new PythonLanguage();

    private class PythonLanguage() : Language(tree_sitter_python())
    {
    }
    [DllImport("tree-sitter-python", CallingConvention = CallingConvention.Cdecl)]
    private static extern IntPtr tree_sitter_python();
}
```
