using System;

namespace TreeSitter;

public sealed class TreeCursor : IDisposable
{
    bool _disposed;
    internal readonly Language Lang;
    internal Binding.TreeCursor NativeCursor;

    internal TreeCursor(Binding.TreeCursor cursor, Language lang)
    {
        NativeCursor = cursor;
        Lang = lang;
    }

    public TreeCursor(Node node, Language lang)
    {
        NativeCursor = Binding.ts_tree_cursor_new(node.NativeNode);
        Lang = lang;
    }

    public void Dispose()
    {
        if (!_disposed)
        {
            Binding.ts_tree_cursor_delete(ref NativeCursor);
            _disposed = true;
        }
    }

    public void Reset(Node node) => Binding.ts_tree_cursor_reset(ref NativeCursor, node.NativeNode);
    public Node CurrentNode() => new (Binding.ts_tree_cursor_current_node(ref NativeCursor));

    public string CurrentField() => Lang.Fields[Binding.ts_tree_cursor_current_field_id(ref NativeCursor)];

    public string CurrentSymbol() => Lang.SymbolName(Binding.ts_node_symbol(Binding.ts_tree_cursor_current_node(ref NativeCursor)));

    public bool GotoParent() => Binding.ts_tree_cursor_goto_parent(ref NativeCursor);

    public bool GotoNextSibling() => Binding.ts_tree_cursor_goto_next_sibling(ref NativeCursor);

    public bool GotoFirstChild() => Binding.ts_tree_cursor_goto_first_child(ref NativeCursor);

    public long GotoFirstChildForOffset(uint offset) => Binding.ts_tree_cursor_goto_first_child_for_byte(ref NativeCursor, offset * sizeof(ushort));

    public long GotoFirstChildForPoint(Point point) => Binding.ts_tree_cursor_goto_first_child_for_point(ref NativeCursor, point);

    public TreeCursor Copy() => new(Binding.ts_tree_cursor_copy(ref NativeCursor), Lang);
}