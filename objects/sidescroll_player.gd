extends Player

@export var jump = -400.0
@export var topdown := false


func move_state(delta) -> void:
	#if randi_range(0,5) == 1:
		#print(global_position)
	if Input.is_action_just_pressed("ui_cancel"):
		topdown = !topdown
	if topdown:
		super(delta)
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = jump

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
