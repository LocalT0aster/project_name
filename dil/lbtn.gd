extends HBoxContainer

var txt = ">"
var selected : bool = false
signal pressed

func _ready():
	$LinkButton.text = txt
	$LinkButton.pressed.connect(onprst)

func select():
	selected = !selected
	$Label.visible = selected

#func innit():
#	$LinkButton.text = txt

func onprst():
	emit_signal("pressed")
