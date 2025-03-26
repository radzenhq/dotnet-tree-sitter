using System;
using System.Runtime.InteropServices;

namespace TreeSitter;

public sealed class Tree : IDisposable
{
    internal IntPtr Ptr;

    internal Tree(IntPtr ptr)
    {
        Ptr = ptr;
    }

    public void Dispose()
    {
        if (Ptr != IntPtr.Zero)
        {
            Binding.ts_tree_delete(Ptr);
            Ptr = IntPtr.Zero;
        }
    }

    public Tree Copy()
    {
        var ptr = Binding.ts_tree_copy(Ptr);
        return ptr != IntPtr.Zero ? new Tree(ptr) : null;
    }

    public Node RootNode() => Node.FromNative(Binding.ts_tree_root_node(Ptr));

    public Node RootNodeWithOffset(uint offsetBytes, Point offsetPoint) => Node.FromNative(Binding.ts_tree_root_node_with_offset(Ptr, offsetBytes, offsetPoint));

    public Language Language()
    {
        var ptr = Binding.ts_tree_language(Ptr);
        return ptr != IntPtr.Zero ? TreeSitter.Language.FromNative(ptr) : null;
    }

    public void Edit(InputEdit edit) => Binding.ts_tree_edit(Ptr, ref edit);
}