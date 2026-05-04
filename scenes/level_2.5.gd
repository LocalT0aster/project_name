extends BaseLevel
## Flappy Bird Level

@export var pipe_amount: int = 10
@export var pipe_height_variance: int = 240
@export var pipe_distance: int = 320


@export var pipes_scene: PackedScene = preload("res://objects/pipe_pair.tscn")
@export var foreground: TileMapLayer
@export var exit: Node2D

func _ready() -> void:
	super ()
	for i in range(pipe_amount):
		var pipe: Node2D = pipes_scene.instantiate()
		pipe.position = Vector2(
			pipe_distance * i,
			randf_range(-pipe_height_variance/2, pipe_height_variance/2)
			)
		foreground.call_deferred("add_child", pipe)
	exit.position = Vector2(pipe_distance * pipe_amount, 0.0)
