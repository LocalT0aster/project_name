extends Node

var save_file_path = "user://slot1.dat"
var progress = 0
var current_enemy_index
var saved_player_position = Vector2.ZERO
var current_player_position = Vector2.ZERO
var current_scene = ""
var previous_scene = ""
var playerhp = 10
var guys = {
	"guy": {
		"name": "guy",
		"gud": true,
		"stats": {"hp": 10, "spd": 5, "att": [5,6]},
		"skills": [
			"cope"
		]
	},
	"knight": {
		"name": "knight",
		"gud": true,
		"stats": {"hp": 10, "spd": 5, "att": [7,8]},
		"skills": [
			"hack-away"
		]
	},
	"recon": {
		"name": "recon",
		"gud": true,
		"stats": {"hp": 10, "spd": 8, "att": [5,6]},
		"skills": [
			"invis"
		]
	},
	"crab": {
		"name": "crab",
		"gud": false,
		"stats": {"hp": 10, "spd": 6, "att": [5,5]}
	}
}
