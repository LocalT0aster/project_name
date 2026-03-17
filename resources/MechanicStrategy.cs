#nullable enable

using Godot;

public abstract partial class MechanicStrategy : Resource
{
    [Export]
    public string DisplayName { get; set; } = "Mechanic";

    public abstract void Apply(MechanicRuntimeState state);
}

public sealed class MechanicRuntimeState
{
    public bool MovementEnabled { get; set; }
}
