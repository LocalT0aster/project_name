extends NPC

func _ready() -> void:
	dialog = {
		"0": {
			"name": "Плейсхолдер",
			"texture": "character_placeholder.png",
			"txt": "Привет?",
			"options": [
				{"text": "Привет", "next": "-1"},
				{"text": "Пока", "next": "-1"},
			]
		},
	}
