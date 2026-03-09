using Godot;
using System;
using Godot.Collections;

/// <summary>
/// Tool that resizes the walls collision shapes
/// </summary>
public partial class NinePatchRectWallsBuilder : Node2D {
    /// left top right bottom margins
    [Export] public Vector4 margin = Vector4.Zero;
    private NinePatchRect npr;

    /// left top right bottom colliders
    [Export(PropertyHint.ArrayType)]
    private Array<PhysicsBody2D> _colliders;
    
    public override void _Ready() {
        try {
            npr = GetParentOrNull<NinePatchRect>();
            if (npr == null) {
                throw new NullReferenceException("NinePatchRect Parent not found");
            }
            if (_colliders == null || _colliders.Count != 4) {
                throw new Exception("Please set colliders properly!");
            }
            if (_colliders[0].GetChildOrNull<CollisionShape2D>(0) == null ||
                     _colliders[0].GetChildOrNull<CollisionShape2D>(0).Shape is not WorldBoundaryShape2D) {
                throw new Exception("Colliders must have WorldBoundaryShape2D shape!");
            }
            npr.Resized += onResized;
            onResized();
        }
        catch (Exception e) {
            GD.PrintErr(e);
        }
    }

    private void onResized() {
        _colliders[0].Position = Vector2.Zero;
        _colliders[1].Position = Vector2.Zero;
        _colliders[2].Position = npr.GetSize();
        _colliders[3].Position = npr.GetSize();
        for (int i = 0; i < 4; ++i) {
            (_colliders[i].GetChild<CollisionShape2D>(0).Shape as WorldBoundaryShape2D).SetDistance(margin[i]);
        }
    }
}
