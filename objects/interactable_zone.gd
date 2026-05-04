extends Area2D

@export var dialog : String = 'Default'
@onready var light: PointLight2D = $PointLight2D


func _on_area_entered(_area: Area2D) -> void:
	light.enabled = true


func _on_area_exited(_area: Area2D) -> void:
	light.enabled = false
