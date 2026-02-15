extends Node

signal change_scene
signal engage
signal save

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func process_general(command, arguments):
	match command:
		"change_scene":
			emit_signal("change_scene", arguments[0])
		"engage":
			emit_signal("engage", arguments[0], arguments[1])
		"save":
			emit_signal("save")

func process_battle(who, cares, target):
	match cares:
		"attack":
			take_v(who, target)

func take_v(attr, dfdr):
	var dmg = rng.randi_range(main.guys[attr].stats.att[0], main.guys[attr].stats.att[1])
	if main.guys.has(dfdr):
		main.guys[dfdr].stats.hp -= dmg
		print("%s takes %s damage" % [dfdr, dmg])

func get_target() -> String:
	var a = main.guys.keys()
	a = a[randi() % a.size()]
	if main.guys[a].gud:
		return a
	else:
		return get_target()
