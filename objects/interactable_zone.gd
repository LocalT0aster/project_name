extends Area2D

@export var dialog : String = 'Default'
@onready var light: PointLight2D = $PointLight2D


func _on_area_entered(area: Area2D) -> void:
	light.enabled = true


func _on_area_exited(area: Area2D) -> void:
	light.enabled = false
