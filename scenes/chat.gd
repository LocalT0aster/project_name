extends TextureButton
@export var dialog : Control

var start_dil = {
		"0": {
			"name": "Плейсхолдер",
			"texture": "character_placeholder.png",
			"txt": "Хммм. Странно",
		},
		"1": {
			"name": "Плейсхолдер",
			"texture": "character_placeholder.png",
			"txt": "Вроде тут должно быть передвижение",
		},
		"2": {
			"name": "Плейсхолдер",
			"texture": "character_placeholder.png",
			"txt": "Попробуй покапаться в панели",
			"options": [
				{"text": "Ок", "next": "-1"},
			]
		},
	}

func _on_pressed() -> void:
	dialog.innit(start_dil)
