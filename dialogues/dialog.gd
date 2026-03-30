extends Resource
class_name Dialog

@export var dil : Dictionary = {
	"0": {
		"name": "Плейсхолдер",
		"texture": "character_placeholder.png",
		"txt": "Привет?",
		"options": [
			{"text": "Да", "next": "1"},
			{"text": "Нет", "next": "-1"},
			{"text": "Хаха", "next": "0"},
			{"text": "Хахаа", "next": "0"}
		]
	},
	"1": {
		"name": "Плейсхолдер",
		"texture": "character_placeholder_angy.png",
		"txt": "Е?",
		"options": [
			{"text": "Да", "next": "-1", "command": ["change_scene", ["res://scenes/theplaceday.tscn"]]},
			{"text": "Нет", "next": "-1"}
		]
	}
}
