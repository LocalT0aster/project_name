extends Control

var ggs = []
var bgs = []
var cbt = preload("res://battle/cbt.tscn")
var queue = []
var current_turn = 0
var current_hero = 0
var link = preload("res://ui/lbtn.tscn")
var command = {
	"who": null,
	"what": null,
	"target": null
}
@export var allies_path : NodePath
@export var enemies_path : NodePath
@export var input_path : NodePath
@onready var allies = get_node(allies_path)
@onready var enemies = get_node(enemies_path)
@onready var input = get_node(input_path)
signal proceed

func _ready():
	innit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		proceed.emit()

func innit():
	refresh()
	for guy in ggs:
		var cbt_inst = cbt.instantiate()
		allies.add_child(cbt_inst)
		cbt_inst.name = guy
	for guy in bgs:
		var cbt_inst = cbt.instantiate()
		enemies.add_child(cbt_inst)
		cbt_inst.name = guy
		cbt_inst.flip_h = true
	show_main_inp()

func refresh():
	ggs = []
	bgs = []
	queue = []
	for guy_key in main.guys:
		var actor = main.guys[guy_key]
		var is_alive = actor.stats.hp > 0
		if actor.gud:
			if is_alive:
				ggs.append(guy_key)
			else:
				if allies.has_node(guy_key):
					allies.get_node(guy_key).queue_free()
		else:
			if is_alive:
				bgs.append(guy_key)
			else:
				if enemies.has_node(guy_key):
					enemies.get_node(guy_key).queue_free()

func ai_state():
	for guy in bgs:
		queue.append({
			"who": guy,
			"what": "attack",
			"target": cp.get_target()
			})
	dosmtn()

func dosmtn():
	hide_mi()
	if current_turn < queue.size():
		var cmd = queue[current_turn]
		cp.process_battle(queue[current_turn]["who"],
		 queue[current_turn]["what"],
		 queue[current_turn]["target"])
		if main.guys[cmd.who].gud:
			var da_cbt = allies.get_node(cmd.who)
			await_action(da_cbt)
			da_cbt.process(cmd)
		else:
			var da_cbt = enemies.get_node(cmd.who)
			await_action(da_cbt)
			da_cbt.process(cmd)
	else:
		print("1")
		eor()

func await_action(da_cbt):
	await da_cbt.done
	ohe()

func ohe():
	current_turn += 1
	dosmtn()

func eor():
	current_turn = 0
	current_hero = 0
	refresh()
	if ggs == []:
		lose()
	elif bgs == []:
		print(ggs,bgs)
		win()
	else:
		show_main_inp()

func lose():
	print("you lost")
	$scene_changer.previous_scene()

func win():
	print("you won")
	$scene_changer.previous_scene()

#INPUT SHIT
var main_input = {
	"options": [
			{"text": "attack", "next": "attack"},
			{"text": "skill", "next": "skill"},
			{"text": "item", "next": "item"},
		]
}
enum {targetst,main_inputst,otherst}
var input_state = targetst
func hide_mi():
	input.visible = false

func show_main_inp():
	input.visible = true
	command = {
	"who": null,
	"what": null,
	"target": null
	}
	input_state = main_inputst
	if current_hero < ggs.size():
		command.who = ggs[current_hero]
		for child in input.get_children():
			child.queue_free()
		for inputi in main_input.options:
			var btn = link.instantiate()
			btn.txt = inputi.text
			btn.connect("pressed", Callable(self, "on_btn_prst").bind(inputi.next))
			input.add_child(btn)
	else:
		ai_state()

func show_skill_input():
	for child in input.get_children():
		child.queue_free()
	for skill in ggs[current_hero].skills:
		var btn = link.instantiate()
		btn.txt = input.name
		btn.connect("pressed", Callable(self, "on_btn_prst").bind(skill))
		input.add_child(btn)

func show_item_input():
	pass

func target():
	input_state = targetst
	for child in input.get_children():
		child.queue_free()
	for da_target in main.guys:
		if main.guys[da_target].stats.hp > 0:
			var btn = link.instantiate()
			btn.txt = da_target
			btn.connect("pressed", Callable(self, "on_btn_prst").bind(da_target))
			input.add_child(btn)
	

func oie():
	current_hero += 1
	show_main_inp()

func on_btn_prst(tg):
	match input_state:
		main_inputst:
			match tg:
				"attack":
					command.what = "attack"
					target()
				"skill":
					show_skill_input()
				"item":
					show_item_input()
		targetst:
			command.target = tg
			queue.append(command)
			oie()
		otherst:
			#need match tg for concret skill
			command.what = tg
			target()
