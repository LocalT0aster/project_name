#nullable enable

using Godot;

[GlobalClass]
public partial class MovementMechanic : MechanicStrategy
{
    public MovementMechanic()
    {
        DisplayName = "Movement";
    }

    public override void Apply(MechanicRuntimeState state)
    {
        state.MovementEnabled = true;
    }
}
