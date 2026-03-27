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

public sealed partial class MechanicEntityState : Resource
{
    private readonly Godot.Collections.Dictionary<StringName, Variant> _values = new();

    public void SetValue(StringName key, Variant value)
    {
        _values[key] = value;
    }

    public bool TryGetValue(StringName key, out Variant value)
    {
        if (_values.TryGetValue(key, out Variant storedValue))
        {
            value = storedValue;
            return true;
        }

        value = default;
        return false;
    }

    public bool GetBool(StringName key, bool defaultValue = false)
    {
        return TryGetValue(key, out Variant value) && value.VariantType == Variant.Type.Bool
            ? value.AsBool()
            : defaultValue;
    }

    public MechanicEntityState DuplicateState()
    {
        var duplicate = new MechanicEntityState();

        foreach (KeyValuePair<StringName, Variant> entry in _values)
        {
            duplicate._values[entry.Key] = entry.Value;
        }

        return duplicate;
    }

    public bool HasSameValues(MechanicEntityState other)
    {
        if (_values.Count != other._values.Count)
        {
            return false;
        }

        foreach (KeyValuePair<StringName, Variant> entry in _values)
        {
            if (!other._values.TryGetValue(entry.Key, out Variant otherValue) || !entry.Value.Equals(otherValue))
            {
                return false;
            }
        }

        return true;
    }
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
