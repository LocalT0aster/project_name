extends RigidBody2D

var held = false
var mouse := false
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_left_mouse"):
		pickup()
	if Input.is_action_just_released("ui_left_mouse"):
		print(linear_velocity.rotated(rotation))
		drop(linear_velocity*mass*-1)

func _physics_process(delta):
	if held:
		global_transform.origin = get_global_mouse_position()
		
func pickup():
	if held:
		return
	held = true
	
func drop(impulse=Vector2.ZERO):
	if held:
		apply_central_impulse(impulse)
		held = false

func _on_mouse_entered() -> void:
	mouse = true


func _on_mouse_exited() -> void:
	mouse = false
