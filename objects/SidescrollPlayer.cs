#nullable enable

using Godot;

public partial class SidescrollPlayer : Player
{
    [Export]
    public float Jump { get; set; } = -400.0f;

    [Export]
    public bool Topdown { get; set; }

    private MechanicManager? _mechanicManager;
    private bool _movementEnabled;

    public override void _Ready()
    {
        base._Ready();

        _mechanicManager = MechanicManager.Instance ?? GetNodeOrNull<MechanicManager>("/root/MechanicManager");
        if (_mechanicManager is null)
        {
            GD.PushWarning($"{nameof(SidescrollPlayer)} could not find the MechanicManager autoload.");
            return;
        }

        _mechanicManager.MovementEnabledChanged += OnMovementEnabledChanged;
        OnMovementEnabledChanged(_mechanicManager.IsMovementEnabled);
    }

    public override void _ExitTree()
    {
        if (_mechanicManager is not null)
        {
            _mechanicManager.MovementEnabledChanged -= OnMovementEnabledChanged;
        }
    }

    public override void MoveState(double delta)
    {
        if (!_movementEnabled)
        {
            return;
        }

        if (!IsOnFloor())
        {
            Velocity += GetGravity() * (float)delta;
        }

        if (Input.IsActionPressed(ActionUp) && IsOnFloor())
        {
            Velocity = new Vector2(Velocity.X, Jump);
        }

        float direction = Input.GetAxis(ActionLeft, ActionRight);
        if (!Mathf.IsZeroApprox(direction))
        {
            Velocity = new Vector2(direction * Speed, Velocity.Y);
        }
        else
        {
            Velocity = new Vector2(Mathf.MoveToward(Velocity.X, 0.0f, Speed), Velocity.Y);
        }

        MoveAndSlide();
    }

    private void OnMovementEnabledChanged(bool enabled)
    {
        _movementEnabled = enabled;
    }
}
