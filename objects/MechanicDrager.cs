#nullable enable

using Godot;

public partial class MechanicDrager : StaticBody2D
{
    public bool Enabled { get; set; }

    public override void _Process(double delta)
    {
        if (!Enabled)
        {
            return;
        }

        GlobalPosition = GetGlobalMousePosition();
    }
}
