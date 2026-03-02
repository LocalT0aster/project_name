extends Node

signal movement_enabled

func process_mechanic():
	movement_enabled.emit()
