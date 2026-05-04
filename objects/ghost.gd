extends CharacterBody2D

@export var follow_who : CharacterBody2D

@export var speed := 300.0
@export var acceleration := 300.0
@export var min_dist := 300.0

func _process(delta: float) -> void:
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	#
	var input_vector : Vector2 = (follow_who.global_position - global_position)
	if input_vector.length() <= min_dist:
		velocity = Vector2.ZERO
	else:
		velocity = velocity.move_toward(input_vector.normalized() * speed,delta * acceleration)
	move_and_slide() 
