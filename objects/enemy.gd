extends CharacterBody2D

@export var speed = 300.0
var direction : float = 1.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()


func hurt(_a, _b):
	queue_free()


func _on_walldetector_body_entered(body: Node2D) -> void:
	if body == self: return
	direction *= -1.0


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body == self or !body.has_method("hurt"): return
	if body.is_in_group("enemy"): return
	body.hurt(1.0,Vector2.ZERO)
