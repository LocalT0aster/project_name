#nullable enable

using Godot;
using System.Collections.Generic;

public partial class MechanicManager : Node
{
    public static MechanicManager? Instance { get; private set; }

    [Signal]
    public delegate void MovementEnabledChangedEventHandler(bool enabled);

    private readonly SortedDictionary<int, MechanicStrategy> _slotMechanics = new();

    public bool IsMovementEnabled { get; private set; }

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

    public void SetSlotMechanic(int slotIndex, MechanicStrategy? strategy)
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
            _slotMechanics[slotIndex] = strategy;
        }

        RebuildState();
    }

    public void process_mechanic()
    {
        RebuildState();
    }

    private void RebuildState()
    {
        var state = new MechanicRuntimeState();

        foreach (MechanicStrategy strategy in _slotMechanics.Values)
        {
            strategy.Apply(state);
        }

        UpdateMovementEnabled(state.MovementEnabled);
    }

    private void UpdateMovementEnabled(bool enabled)
    {
        if (IsMovementEnabled == enabled)
        {
            return;
        }

        IsMovementEnabled = enabled;
        EmitSignal(SignalName.MovementEnabledChanged, enabled);
    }
}
