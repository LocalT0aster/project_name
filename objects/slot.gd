extends TextureRect
@export var index : int
var strategy : Strategy :
	set(value):
		MechanicManager.process_mechanic()

func process_mechanic(_mechanic):
	MechanicManager.process_mechanic()
