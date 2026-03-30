extends StaticBody2D


func open():
	$Sprite2D.hide()
	$CollisionShape2D.disabled = true

func close():
	$Sprite2D.show()
	$CollisionShape2D.disabled = false
