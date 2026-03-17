#nullable enable

using Godot;

public partial class MechanicSlot : TextureRect
{
    [Export]
    public int Index { get; set; } = -1;

    public Mechanic? CurrentMechanic { get; private set; }

    public override void _Ready()
    {
        if (Index >= 0)
        {
            return;
        }

        Node? slotRoot = GetParent()?.GetParent();
        Index = slotRoot?.GetIndex() ?? 0;
    }

    public void ProcessMechanic(Mechanic mechanic)
    {
        if (CurrentMechanic is not null && CurrentMechanic != mechanic)
        {
            CurrentMechanic.EjectFromSlot(this);
        }

        CurrentMechanic = mechanic;
        mechanic.AssignToSlot(this);
        GetManager()?.SetSlotMechanic(Index, mechanic.Strategy);
    }

    public void ClearMechanic(Mechanic mechanic)
    {
        if (CurrentMechanic != mechanic)
        {
            return;
        }

        CurrentMechanic = null;
        GetManager()?.SetSlotMechanic(Index, null);
    }

    public bool ContainsGlobalPoint(Vector2 globalPoint)
    {
        return GetGlobalRect().HasPoint(globalPoint);
    }

    private MechanicManager? GetManager()
    {
        return MechanicManager.Instance ?? GetNodeOrNull<MechanicManager>("/root/MechanicManager");
    }
}
