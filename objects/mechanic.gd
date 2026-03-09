extends RigidBody2D

var slot: Control
var held: bool = false
var mouse: bool = false

@export var strategy : Strategy

func _ready() -> void:
	pickup()
	drop(false)

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("ui_left_mouse"):
		if mouse:
			pickup()
	if Input.is_action_just_released("ui_left_mouse"):
		drop(slot_available())
# -slot.global_position
func slot_available():
	for s_slot in get_tree().get_nodes_in_group("Slot"):
		slot = s_slot
		if slot.get_global_rect().has_point(get_global_mouse_position()):
			#move this
			slot.process_mechanic(self)
			return true
	slot = null
	return false

func _physics_process(_delta):
	pass
	#if held:
		#global_transform.origin = get_global_mouse_position()
	#if slot:
		#global_position = slot.global_position
func pickup():
	if held:
		return
	held = true
	slot = null
	$StaticBody2D.global_position =  get_global_mouse_position()
	$StaticBody2D.enabled = true
	$PinJoint2D.global_position = get_global_mouse_position()
	$PinJoint2D.set_node_b($StaticBody2D.get_path())
	freeze = false
func drop(sloted : bool):
	if held:
		held = false
		$StaticBody2D.enabled = false
		if !sloted:
			$PinJoint2D.set_node_b("")
		else:
			freeze = true
			set_deferred("rotation", 0.0)
			set_deferred("global_position",
				slot.global_position + slot.size/2)


func _on_mouse_entered() -> void:
	mouse = true


func _on_mouse_exited() -> void:
	mouse = false
