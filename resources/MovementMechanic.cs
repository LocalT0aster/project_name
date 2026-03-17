#nullable enable

using Godot;

[GlobalClass]
public partial class MovementMechanic : MechanicStrategy
{
    public MovementMechanic()
    {
        DisplayName = "Movement";
    }

    public override void Apply(MechanicRuntimeState state, MechanicTarget target)
    {
        state.For(target).MovementEnabled = true;
    }
}
