extends NPC

func _ready() -> void:
	dialog = {
		"0": {
			"name": "Плейсхолдер",
			"texture": "character_placeholder.png",
			"txt": "Привет?",
			"options": [
				{"text": "Привет", "next": "1"},
				{"text": "Пока", "next": "2"},
			]
		},
		"1": {
			"name": "Плейсхолдер",
			"texture": "character_placeholder.png",
			"txt": "Это тестовый диалог чтобы показать возможности диалоговой системы!",
			"options": [
				{"text": "Круто", "next": "-1"},
				{"text": "Мда", "next": "2"}
			]
		},
		"2": {
			"name": "Плейсхолдер",
			"texture": "character_placeholder_angy.png",
			"txt": "Ну не надо быть таким грубым",
			"options": [
				{"text": "Прости :(", "next": "-1"},
			]
		}
	}
