#nullable enable

using Godot;
using System.Collections.Generic;

public enum MechanicTarget
{
    Player = 0,
    Golem = 1
}

public abstract partial class MechanicStrategy : Resource
{
    [Export]
    public string DisplayName { get; set; } = "Mechanic";

    public abstract void Apply(MechanicRuntimeState state, MechanicTarget target);
}

public sealed class MechanicEntityState
{
    public bool MovementEnabled { get; set; }
}

public sealed class MechanicRuntimeState
{
    private readonly Dictionary<MechanicTarget, MechanicEntityState> _entityStates = new();

    public MechanicEntityState For(MechanicTarget target)
    {
        if (_entityStates.TryGetValue(target, out MechanicEntityState? entityState))
        {
            return entityState;
        }

        entityState = new MechanicEntityState();
        _entityStates[target] = entityState;
        return entityState;
    }
}
