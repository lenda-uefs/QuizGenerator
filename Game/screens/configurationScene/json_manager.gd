extends Node

#warning-ignore:unassigned_variable
var tex
#warning-ignore:unassigned_variable
var img
var dir
var nfiles

func _ready():
	$FileDialog.set_filters(PoolStringArray(["*.json"]))
	$AnimationPlayer.play("logoAnimation", -1, 1.0, false)
	yield($AnimationPlayer, "animation_finished")
	yield(get_tree().create_timer(1), "timeout")
	$AnimationPlayer.play_backwards("logoAnimation", -1)
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("logo_leaving", -1, 1.0, false)
	yield($AnimationPlayer, "animation_finished")
	nfiles = _count_old_configFiles()
	if(nfiles == 0):
		$AnimationPlayer.play("opening", -1, 1.0, false)
		yield($AnimationPlayer, "animation_finished")
	elif(nfiles == 1):
		_on_FileDialog_file_selected("user://config_files/file.json")


func load_dialogue(file_path) -> Dictionary:
	var file = File.new()
	assert file.file_exists(file_path)
	if(nfiles==0):
		dir = Directory.new()
		dir.copy(file_path, "user://config_files/file.json")
	file.open(file_path, file.READ)
	var dialogue = parse_json(file.get_as_text())
	assert dialogue.size()>0
	return dialogue


func delete_old_Files():
	dir = Directory.new()
	if dir.open("user://images") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if(!dir.current_is_dir()):
				print("Found file: " + file_name)
				dir.remove(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path pra apagar.")


func _count_old_configFiles() -> int:
	dir = Directory.new()
	var nFiles = 0
	if(!dir.dir_exists("user://config_files")):
		dir.open("user://")
		dir.make_dir("config_files")
	if(!dir.dir_exists("user://images")):
		dir.open("user://")
		dir.make_dir("images")
	else:
		if dir.open("user://config_files") == OK:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while (file_name != ""):
				if(!dir.current_is_dir()):
					nFiles = nFiles+1
					print("Found file: " + file_name)
				file_name = dir.get_next()
		else:
			print("An error occurred when trying to access the path pra contar.")
	return nFiles


func _on_carregarArquivo_pressed():
	#$option2/baixarModelo.set_block_signals(true)
	$FileDialog.popup_centered()


func _on_FileDialog_file_selected(path):
	if(nfiles == 0):
		$AnimationPlayer.play_backwards("opening", -1)
		yield($AnimationPlayer, "animation_finished")
		$Popup.popup_centered()
		$AnimationPlayer.play("configuration", -1, 1.0, false)
	else:
		$Popup2.popup_centered()
		$AnimationPlayer.play("configuration2", -1, 1.0, false)
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
	global_config.game_color = dic["Game_color_pattern"]
	if(global_config.game_color["r"].empty()):
		global_config.game_color["r"] = 0.66
		global_config.game_color["g"] = 0.88
		global_config.game_color["b"] = 0.96
		global_config.game_color["a"] = 1
	if(!dic["Title_screen_background"].empty()):
		if(nfiles>0):
			var path = dic["Title_screen_background"]
			path.erase(0,path.find_last("/")+1)
			path = "user://images/" + path
			global_config.title_screen_background = _load_process(tex, img, path)
		else:
			global_config.title_screen_background = _load_process(tex, img, dic["Title_screen_background"])
	else:
		global_config.title_screen_background = null
	if(nfiles>0):
		_importInsideImages()
	else:
		_importImages()


func _importInsideImages():
	var path
	for h in range(1, global_config.stories.size()+1):
		for k in range (1, global_config.stories["Story_" + str(h)]["Questions"].size()+1):
			for j in range (1, 3):
				path = global_config.stories["Story_" + str(h)]["Questions"]["Question_" + str(k)]["option_" + str(j)]
				path.erase(0,path.find_last("/")+1)
				path = "user://images/" + path
				print(path)
				global_config.stories["Story_" + str(h)]["Questions"]["Question_" + str(k)]["option_" + str(j)] = _load_process(tex, img, path) 
		path = global_config.stories["Story_" + str(h)]["Story_cover"]
		path.erase(0,path.find_last("/")+1)
		path = "user://images/" + path
		global_config.stories["Story_" + str(h)]["Story_cover"] = _load_process(tex, img, path)
	var next_screen = load("res://screens/titleScreen/titleScreen.tscn")
	yield(get_tree().create_timer(2), "timeout")
	if(nfiles==0):
		$AnimationPlayer.play("config_done", -1, 1.0, false)
	else:
		$AnimationPlayer.play("config_done2", -1, 1.0, false)
	yield($AnimationPlayer, "animation_finished")
	yield(get_tree().create_timer(0.6), "timeout")
	get_tree().call_group("managers", "loading_process_ended")
	#warning-ignore:return_value_discarded
	get_tree().change_scene_to(next_screen)


func _importImages():
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
	var extension = loadPath
	extension.erase(0,extension.find_last("/")+1)
	print("Extensão:" + extension)
	if(nfiles == 0):
		dir = Directory.new()
		dir.copy(loadPath, "user://images/" + extension)
	tex = ImageTexture.new()
	img = Image.new()
	img.load(loadPath)
	tex.create_from_image(img)
	return tex


func _on_baixarModelo_pressed():
	dir = Directory.new()
	dir.copy("res://model.json", "C://Users/Public/Downloads/model.json")
	#warning-ignore:return_value_discarded
	OS.shell_open("C://Users/Public/Downloads")
	#warning-ignore:return_value_discarded
	OS.shell_open("C://Users/Public/Downloads/model.json")

func _on_FileDialog_confirmed():
	$option2/baixarModelo.set_block_signals(false)