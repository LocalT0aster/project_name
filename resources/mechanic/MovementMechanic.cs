#nullable enable

using Godot;

[GlobalClass]
public partial class MovementMechanic : MechanicStrategy
{
    public static readonly StringName EnabledStateKey = "movement_enabled";

    public MovementMechanic()
    {
        DisplayName = "Movement";
    }

    public override void Apply(MechanicRuntimeState state, MechanicTarget target)
    {
        state.For(target).SetValue(EnabledStateKey, true);
    }
}
