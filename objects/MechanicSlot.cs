#nullable enable

using Godot;

public partial class MechanicSlot : VBoxContainer
{
    private const string LabelPath = "Label";
    private const string DropAreaPath = "CenterContainer/Control";

    [Export]
    public int Index { get; set; } = -1;

    [Export]
    public MechanicTarget Target { get; set; } = MechanicTarget.Player;

    public Mechanic? CurrentMechanic { get; private set; }

    private Label _label = null!;
    private TextureRect _dropArea = null!;

    public Vector2 SnapPosition => _dropArea.GlobalPosition + (_dropArea.Size / 2.0f);

    public override void _Ready()
    {
        _label = GetNode<Label>(LabelPath);
        _dropArea = GetNode<TextureRect>(DropAreaPath);

        if (Index < 0)
        {
            Index = GetIndex();
        }

        _label.Text = BuildLabel(Target);
    }

    public void ProcessMechanic(Mechanic mechanic)
    {
        if (CurrentMechanic is not null && CurrentMechanic != mechanic)
        {
            CurrentMechanic.EjectFromSlot(this);
        }

        CurrentMechanic = mechanic;
        mechanic.AssignToSlot(this);
        GetManager()?.SetSlotMechanic(Index, Target, mechanic.Strategy);
    }

    public void ClearMechanic(Mechanic mechanic)
    {
        if (CurrentMechanic != mechanic)
        {
            return;
        }

        CurrentMechanic = null;
        GetManager()?.SetSlotMechanic(Index, Target, null);
    }

    public bool ContainsGlobalPoint(Vector2 globalPoint)
    {
        return _dropArea.GetGlobalRect().HasPoint(globalPoint);
    }

    private MechanicManager? GetManager()
    {
        return MechanicManager.Instance ?? GetNodeOrNull<MechanicManager>("/root/MechanicManager");
    }

    private static string BuildLabel(MechanicTarget target)
    {
        return $"{target}_process.gd";
    }
}
