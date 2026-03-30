extends Control

@export var txt : NodePath
@export var cnm : NodePath
@export var chcs : NodePath
@export var chcswin : NodePath
@export var ind : NodePath
@export var name_window : Control
@onready var indicator = get_node(ind)
@onready var text = get_node(txt)
@onready var cname = get_node(cnm)
@onready var choices = get_node(chcs)
@onready var chcswindow = get_node(chcswin)
@export var textSpeed = 0.05
var finished = false
var link = preload("res://dil/lbtn.tscn")
var dialogdata
@export var guypath : NodePath
@onready var guy = get_node(guypath)
#var dilstart = "0"
var select = 0
var opt = false
var next = "0"
var rng = RandomNumberGenerator.new()
signal finished_dialog

var test_dialog = {
	"0": {
		"name": "Плейсхолдер",
		"texture": "character_placeholder.png",
		"txt": "Привет?",
		"options": [
			{"text": "Да", "next": "1"},
			{"text": "Нет", "next": "-1"},
			{"text": "Хаха", "next": "0"},
			{"text": "Хахаа", "next": "0"}
		]
	},
	"1": {
		"name": "Плейсхолдер",
		"texture": "character_placeholder_angy.png",
		"txt": "Е?",
		"options": [
			{"text": "Да", "next": "-1", "command": ["change_scene", ["res://scenes/theplaceday.tscn"]]},
			{"text": "Нет", "next": "-1"}
		]
	}
}

func _ready():
	rng.randomize()
	$Timer.wait_time = textSpeed
	#innit(test_dialog)


#func _process(_delta):
	#if Input.is_action_just_pressed("ui_accept"):
		#if !finished:
			#text.visible_characters = len(text.text)
		#elif !opt:
			#setup(next)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		if opt:
			choices.get_children()[select].onprst()
	if event.is_action_released("ui_left_mouse") or event.is_action_released("ui_accept"):
		if !finished:
			text.visible_characters = len(text.text)
		elif !opt:
			setup(next)
	if event.is_action_pressed("ui_down") and opt:
		var children = choices.get_children()
		if select == children.size() - 1:
			children[children.size() - 1].select()
			select = 0
			children[select].select()
		else:
			children[select].select()
			select += 1
			children[select].select()
	if event.is_action_pressed("ui_up") and opt:
		var children = choices.get_children()
		if select == 0:
			children[0].select()
			select = children.size() - 1
			children[select].select()
		else:
			children[select].select()
			select -= 1
			children[select].select()

func innit(didaat):
	show()
	dialogdata = didaat
	setup("0")

func setup(dilstart):
	indicator.hide()
	finished = false
	chcswindow.hide()
	
	var data = dialogdata[dilstart]
	#if "command" in data:
		#cp.process_general(data.command[0], data.command[1])
	#
	#if "sound" in data:
		#ostmanager.playsound(data.sound)
	if "texture" in data:
		guy.show()
		guy.texture = load("res://img/characters/" + data.texture)
	else:
		guy.hide()
	
	text.bbcode_text = data.txt
	cname.text = data.name
	
	text.visible_characters = 0
	visible = true
	while text.visible_characters < len(text.text):
		text.visible_characters += 1
		
		$Timer.start()
		await $Timer.timeout
	
	
	
	if "options" in data:
		select = 0
		opt = true
		for child in choices.get_children():
			child.queue_free()
		var new_children = []
		for option in data.options:
			
			var btn = link.instantiate()
			btn.txt = option.text
			btn.pressed.connect(on_btn_prst.bind(option))
#			btn.innit()
#			btn.grab_click_focus()
			new_children.append(btn)
			choices.add_child(btn)
		new_children[0].select()
	else:
		opt = false
		next = str(int(next) + 1)
	
#	choices.get_child(1).grab_focus()
	
	if opt:
		chcswindow.show()
	finished = true
	indicator.visible = true

func on_btn_prst(option):
	#if "command" in option:
		#cp.process_general(option.command[0], option.command[1])
	if finished:
		chcswindow.hide()
		if option.next == "-1":
			stop()
		else:
			next = option.next
			setup(option.next)
	else:
		pass

func stop():
	finished = false
	for child in choices.get_children():
		child.queue_free()
	opt = false
	chcswindow.hide()
	visible = false
	next = "0"
	emit_signal("finished_dialog")
