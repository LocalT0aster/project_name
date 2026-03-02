extends Resource

class_name Option

@export_enum(
	"BOOL", "SLIDER", "TEXT","ENUM","SLOT"
	) var type : String
@export var name : String
@export_group("Slider")
@export var is_float : bool = true
@export var min : float = 0.0
@export var max : float = 1.0
@export var current : float = 0.0
@export var min_int : int = 0
@export var max_int : int = 1
@export var current_int : int = 0
@export_group("","")
@export var text : String
@export var enum_elements : Array
@export var slot : Variant #Slot
