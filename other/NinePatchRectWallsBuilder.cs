using Godot;
using System;
using Godot.Collections;

/// <summary>
/// Tool that resizes the walls collision shapes
/// </summary>
public partial class NinePatchRectWallsBuilder : Node2D {
    /// left top right bottom margins
    [Export] public Vector4 Margin = Vector4.Zero;
    [Export] public bool AddHalfPatchMargin = true;
    private NinePatchRect _npr;

    /// left top right bottom colliders
    [Export(PropertyHint.ArrayType)]
    private Array<PhysicsBody2D> _colliders;
    
    public override void _Ready() {
        try {
            _npr = GetParentOrNull<NinePatchRect>();
            // Validity checks
            if (_npr == null) {
                throw new NullReferenceException("NinePatchRect Parent not found");
            }
            if (_colliders == null || _colliders.Count != 4) {
                throw new Exception("Please set colliders properly!");
            }
            if (_colliders[0].GetChildOrNull<CollisionShape2D>(0) == null ||
                     _colliders[0].GetChildOrNull<CollisionShape2D>(0).Shape is not WorldBoundaryShape2D) {
                throw new Exception("Colliders must have WorldBoundaryShape2D shape!");
            }
            // Set WorldBoundaryShape2D margins (via distance property)
            for (int i = 0; i < 4; ++i) {
                if (AddHalfPatchMargin)
                    Margin[i] += _npr.GetPatchMargin((Side)i) / 2f;
                (_colliders[i].GetChild<CollisionShape2D>(0).Shape as WorldBoundaryShape2D)!.SetDistance(Margin[i]);
            }
            // Move top left edges to zero just to be sure
            _colliders[0].Position = Vector2.Zero;
            _colliders[1].Position = Vector2.Zero;
            // Connect signal and call
            _npr.Resized += OnResized;
            OnResized();
        }
        catch (Exception e) {
            GD.PrintErr($"NinePatchRectWallsBuilder.cs: {e}");
        }
    }

    private void OnResized() {
        _colliders[2].Position = _npr.GetSize();
        _colliders[3].Position = _npr.GetSize();
    }
}
