extends Node

var playing_track_name

func _on_timer_timeout():
	for trackindex in get_child_count():
		if get_child(trackindex) is AudioStreamPlayer:
			get_child(trackindex).finished.connect(loop.bind(get_child(trackindex).name))


func loop(trackname):
	if !has_node(trackname+'looped'):
		playing_track_name = trackname
		find_child(str(trackname)).play()
		return
	playing_track_name = trackname + 'looped'
	find_child(trackname+'looped').play()

func playsound(soundname):
	get_child(0).find_child(soundname).play()

func starttrack(trackname,pause):
	var track = find_child(trackname)
	if pause:
		if playing_track_name != null:
			find_child(playing_track_name).stream_paused = true
		playing_track_name = trackname
		track.play()
		return
	
	if playing_track_name != null:
		find_child(playing_track_name).stop()
	
	playing_track_name = trackname
	
	if !has_node(trackname):
		print("song not found")
	
	if track.stream_paused:
		track.stream_paused = false
	else:
		track.play()
