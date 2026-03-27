#nullable enable

using Godot;

public partial class MechanicCard : RigidBody2D
{
    private const string ActionLeftMouse = "ui_left_mouse";
    private const string GroupSlot = "Slot";
    private const string RotationProperty = "rotation";
    private const string GlobalPositionProperty = "global_position";
    private const string DragProxyPath = "StaticBody2D";
    private const string PinJointPath = "PinJoint2D";

    [Export]
    public MechanicStrategy Strategy { get; set; } = new MovementMechanic();

    private MechanicDrager _dragProxy = null!;
    private PinJoint2D _pinJoint = null!;
    private MechanicSlot? _assignedSlot;
    private bool _held;
    private bool _mouseOver;

    public override void _Ready()
    {
        _dragProxy = GetNode<MechanicDrager>(DragProxyPath);
        _pinJoint = GetNode<PinJoint2D>(PinJointPath);

        Pickup();
        Drop(false);
    }

    public override void _Input(InputEvent @event)
    {
        if (Input.IsActionPressed(ActionLeftMouse) && _mouseOver)
        {
            Pickup();
        }

        if (Input.IsActionJustReleased(ActionLeftMouse))
        {
            Drop(TryAssignToSlot());
        }
    }

    public void AssignToSlot(MechanicSlot slot)
    {
        _assignedSlot = slot;
    }

    public void EjectFromSlot(MechanicSlot slot)
    {
        if (_assignedSlot != slot)
        {
            return;
        }

        _assignedSlot = null;
        Freeze = false;
    }

    private bool TryAssignToSlot()
    {
        foreach (Node node in GetTree().GetNodesInGroup(GroupSlot))
        {
            if (node is not MechanicSlot slot)
            {
                continue;
            }

            if (!slot.ContainsGlobalPoint(GetGlobalMousePosition()))
            {
                continue;
            }

            slot.ProcessMechanic(this);
            return true;
        }

        return false;
    }

    private void Pickup()
    {
        if (_held)
        {
            return;
        }

        if (_assignedSlot is not null)
        {
            MechanicSlot previousSlot = _assignedSlot;
            _assignedSlot = null;
            previousSlot.ClearMechanic(this);
        }

        _held = true;
        _dragProxy.GlobalPosition = GetGlobalMousePosition();
        _dragProxy.Enabled = true;
        _pinJoint.GlobalPosition = GetGlobalMousePosition();
        _pinJoint.NodeB = _dragProxy.GetPath();
        Freeze = false;
    }

    private void Drop(bool slotted)
    {
        if (!_held)
        {
            return;
        }

        _held = false;
        _dragProxy.Enabled = false;

        if (!slotted || _assignedSlot is null)
        {
            _pinJoint.NodeB = new NodePath(string.Empty);
            return;
        }

        Freeze = true;
        SetDeferred(RotationProperty, 0.0f);
        SetDeferred(GlobalPositionProperty, _assignedSlot.SnapPosition);
    }

    private void _on_mouse_entered()
    {
        _mouseOver = true;
    }

    private void _on_mouse_exited()
    {
        _mouseOver = false;
    }
}
