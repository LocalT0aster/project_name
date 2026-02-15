extends CharacterBody2D

class_name Player

@export var speed = 100
@export var acceleration = 500
@export var friction = 500

enum {
	MOVE,
	DIALOG
}

var state = MOVE

#func _ready() -> void:
	#$CanvasLayer/dbshechkka.finished_dialog.connect(func(): state = MOVE)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and state != DIALOG:
		for body in $interaction_area.get_overlapping_bodies():
			if body.has_method("start_dil"):
				$CanvasLayer/dialogue_system.innit(body.start_dil())
				state = DIALOG
				await $CanvasLayer/dialogue_system.finished_dialog
				state = MOVE
				break

func get_input_dir():
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			move_state(delta)
		DIALOG:
			dil_state()

func dil_state():
	pass
#
func move_state(delta):
	var input_vector = get_input_dir()
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * speed,delta * acceleration)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * friction)
	move_and_slide()
