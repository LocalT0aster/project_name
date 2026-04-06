extends StaticBody2D
func toggle(on):
	if on:
		open()
	else:
		close()

func open():
	$Sprite2D.hide()
	$CollisionShape2D.set_deferred("disabled",true)

func close():
	$Sprite2D.show()
	$CollisionShape2D.set_deferred("disabled",false)
