#nullable enable

using Godot;

public partial class Player : CharacterBody2D
{
    private const string ActionAccept = "ui_accept";
    protected const string ActionRight = "ui_right";
    protected const string ActionLeft = "ui_left";
    protected const string ActionDown = "ui_down";
    protected const string ActionUp = "ui_up";
    private const string StartDialogMethod = "start_dil";
    private const string InitDialogMethod = "innit";
    private const string FinishedDialogSignal = "finished_dialog";

    [Export]
    public float Speed { get; set; } = 100.0f;

    [Export]
    public float Acceleration { get; set; } = 500.0f;

    [Export]
    public float Friction { get; set; } = 500.0f;

    protected enum PlayerState
    {
        Move,
        Dialog
    }

    protected PlayerState State = PlayerState.Move;

    private Area2D _interactionArea = null!;
    private Node _dialogueSystem = null!;

    public override void _Ready()
    {
        _interactionArea = GetNode<Area2D>("interaction_area");
        _dialogueSystem = GetNode<Node>("CanvasLayer/dialogue_system");
    }

    public override async void _UnhandledInput(InputEvent @event)
    {
        if (!@event.IsActionPressed(ActionAccept) || State == PlayerState.Dialog)
        {
            return;
        }

        foreach (Node2D body in _interactionArea.GetOverlappingBodies())
        {
            if (!body.HasMethod(StartDialogMethod))
            {
                continue;
            }

            _dialogueSystem.Call(InitDialogMethod, body.Call(StartDialogMethod));
            State = PlayerState.Dialog;
            await ToSignal(_dialogueSystem, FinishedDialogSignal);
            State = PlayerState.Move;
            break;
        }
    }

    public override void _PhysicsProcess(double delta)
    {
        switch (State)
        {
            case PlayerState.Move:
                MoveState(delta);
                break;
            case PlayerState.Dialog:
                DialogState();
                break;
        }
    }

    protected Vector2 GetInputDir()
    {
        return new Vector2(
            Input.GetActionStrength(ActionRight) - Input.GetActionStrength(ActionLeft),
            Input.GetActionStrength(ActionDown) - Input.GetActionStrength(ActionUp)
        ).Normalized();
    }

    protected virtual void DialogState()
    {
    }

    public virtual void MoveState(double delta)
    {
        Vector2 inputVector = GetInputDir();

        if (inputVector != Vector2.Zero)
        {
            Velocity = Velocity.MoveToward(inputVector * Speed, (float)delta * Acceleration);
        }
        else
        {
            Velocity = Velocity.MoveToward(Vector2.Zero, (float)delta * Friction);
        }

        MoveAndSlide();
    }
}
