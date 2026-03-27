#nullable enable

using Godot;
using System;
using System.Collections.Generic;

public partial class MechanicManager : Node
{
    public static MechanicManager? Instance { get; private set; }

    [Signal]
    public delegate void TargetStateChangedEventHandler(long target, MechanicEntityState state);

    private readonly SortedDictionary<int, (MechanicTarget Target, MechanicStrategy Strategy)> _slotMechanics = new();
    private readonly Dictionary<MechanicTarget, MechanicEntityState> _statesByTarget = new();

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

    public MechanicEntityState GetTargetState(MechanicTarget target)
    {
        return _statesByTarget.TryGetValue(target, out MechanicEntityState? state)
            ? state.DuplicateState()
            : new MechanicEntityState();
    }

    public bool TryGetTargetValue(MechanicTarget target, StringName key, out Variant value)
    {
        if (_statesByTarget.TryGetValue(target, out MechanicEntityState? state))
        {
            return state.TryGetValue(key, out value);
        }

        value = default;
        return false;
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
            UpdateTargetState(target, state.For(target));
        }
    }

    private void UpdateTargetState(MechanicTarget target, MechanicEntityState state)
    {
        if (_statesByTarget.TryGetValue(target, out MechanicEntityState? currentState) && currentState.HasSameValues(state))
        {
            return;
        }

        MechanicEntityState snapshot = state.DuplicateState();
        _statesByTarget[target] = snapshot;
        EmitSignal(SignalName.TargetStateChanged, (long)target, snapshot.DuplicateState());
    }
}
