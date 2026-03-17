#nullable enable

using Godot;
using System;
using System.Collections.Generic;

public partial class MechanicManager : Node
{
    public static MechanicManager? Instance { get; private set; }

    [Signal]
    public delegate void MovementEnabledChangedEventHandler(long target, bool enabled);

    private readonly SortedDictionary<int, (MechanicTarget Target, MechanicStrategy Strategy)> _slotMechanics = new();
    private readonly Dictionary<MechanicTarget, bool> _movementEnabledByTarget = new();

    public override void _Ready()
    {
        Instance = this;
        RebuildState();
    }

    public override void _ExitTree()
    {
        if (Instance == this)
        {
            Instance = null;
        }
    }

    public void SetSlotMechanic(int slotIndex, MechanicTarget target, MechanicStrategy? strategy)
    {
        if (slotIndex < 0)
        {
            GD.PushWarning($"{nameof(MechanicManager)} received invalid slot index {slotIndex}.");
            return;
        }

        if (strategy is null)
        {
            _slotMechanics.Remove(slotIndex);
        }
        else
        {
            _slotMechanics[slotIndex] = (target, strategy);
        }

        RebuildState();
    }

    public bool IsMovementEnabled(MechanicTarget target)
    {
        return _movementEnabledByTarget.TryGetValue(target, out bool enabled) && enabled;
    }

    public void process_mechanic()
    {
        RebuildState();
    }

    private void RebuildState()
    {
        var state = new MechanicRuntimeState();

        foreach (var slotMechanic in _slotMechanics.Values)
        {
            slotMechanic.Strategy.Apply(state, slotMechanic.Target);
        }

        foreach (MechanicTarget target in Enum.GetValues<MechanicTarget>())
        {
            UpdateMovementEnabled(target, state.For(target).MovementEnabled);
        }
    }

    private void UpdateMovementEnabled(MechanicTarget target, bool enabled)
    {
        if (IsMovementEnabled(target) == enabled)
        {
            return;
        }

        _movementEnabledByTarget[target] = enabled;
        EmitSignal(SignalName.MovementEnabledChanged, (long)target, enabled);
    }
}
