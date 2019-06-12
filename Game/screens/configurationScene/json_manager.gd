extends Node

signal configurationDone

func _ready():
	$FileDialog.set_filters(PoolStringArray(["*.json"]))
	$AnimationPlayer.play("logoAnimation", -1, 1.0, false)
	yield($AnimationPlayer, "animation_finished")
	yield(get_tree().create_timer(1), "timeout")
	$AnimationPlayer.play_backwards("logoAnimation", -1)
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("logo_leaving", -1, 1.0, false)
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("opening", -1, 1.0, false)
	yield($AnimationPlayer, "animation_finished")


func load_dialogue(file_path) -> Dictionary:
	var file = File.new()
	assert file.file_exists(file_path)
	file.open(file_path, file.READ)
	var dialogue = parse_json(file.get_as_text())
	assert dialogue.size()>0
	return dialogue


func _on_carregarArquivo_pressed():
	#$option2/baixarModelo.set_block_signals(true)
	$FileDialog.popup_centered()


func _on_FileDialog_file_selected(path):
	$AnimationPlayer.play_backwards("opening", -1)
	yield($AnimationPlayer, "animation_finished")
	$Popup.popup_centered()
	$AnimationPlayer.play("configuration", -1, 1.0, false)
	var dic = load_dialogue(path)
	_set_game_configuration(dic)


func _set_game_configuration(dic):
	global_config.game_title = dic["Game_title"]
	global_config.stories = dic["Stories"]
	var snd_file = File.new()
	snd_file.open(dic["Background_sound_path"], File.READ)
	var stream = AudioStreamOGGVorbis.new()
	stream.data = snd_file.get_buffer(snd_file.get_len())
	snd_file.close()
	global_config.background_sound.stream = stream
	emit_signal("configurationDone")
	_importImages()


func _importImages():
	#warning-ignore:unassigned_variable
	var tex
	#warning-ignore:unassigned_variable
	var img
	for h in range(1, global_config.stories.size()+1):
		for k in range (1, global_config.stories["Story_" + str(h)]["Questions"].size()+1):
			for j in range (1, 3):
				global_config.stories["Story_" + str(h)]["Questions"]["Question_" + str(k)]["option_" + str(j)] = _load_process(tex, img, global_config.stories["Story_" + str(h)]["Questions"]["Question_" + str(k)]["option_" + str(j)]) 
		global_config.stories["Story_" + str(h)]["Story_cover"] = _load_process(tex, img, global_config.stories["Story_" + str(h)]["Story_cover"])
	var next_screen = load("res://screens/titleScreen/titleScreen.tscn")
	yield(get_tree().create_timer(2), "timeout")
	$AnimationPlayer.play("config_done", -1, 1.0, false)
	yield($AnimationPlayer, "animation_finished")
	yield(get_tree().create_timer(0.6), "timeout")
	get_tree().call_group("managers", "loading_process_ended")
	#warning-ignore:return_value_discarded
	get_tree().change_scene_to(next_screen)


func _load_process(tex, img, loadPath) -> ImageTexture:
	tex = ImageTexture.new()
	img = Image.new()
	img.load(loadPath)
	tex.create_from_image(img)
	return tex


func _on_baixarModelo_pressed():
	var dir = Directory.new()
	dir.copy("res://model.json", "C://Users/Public/Downloads/model.json")
	#warning-ignore:return_value_discarded
	OS.shell_open("C://Users/Public/Downloads")
	#warning-ignore:return_value_discarded
	OS.shell_open("C://Users/Public/Downloads/model.json")

func _on_FileDialog_confirmed():
	$option2/baixarModelo.set_block_signals(false)
