extends Node2D

var listenStory = preload("res://screens/listenStoryScene/listenHistory.tscn")
var readStory = preload("res://screens/readStoryScene/readStory.tscn")
var previous_scene = load("res://screens/titleScreen/titleScreen.tscn")
var musicOff = preload("res://sprites/images/soundOff.png")
var musicOn = preload("res://sprites/images/soundOn.png")

var next_scene = preload("res://screens/gameScene/game.tscn")
var next_scene2 = preload("res://screens/gameScene2/game2.tscn")


func _ready():
	$background.set_frame_color(Color(global_config.game_color["r"], global_config.game_color["g"], global_config.game_color["b"]))
	_set_stories()
	get_tree().set_auto_accept_quit(false)
	get_tree().set_quit_on_go_back(false)
	if(global_config.music == true):
		$musicButton.set_texture(musicOn)
	else:
		$musicButton.set_texture(musicOff)
	get_node("/root/Node2D/AnimationPlayer").play("transition", -1, 1.0, false)
	yield(get_node("/root/Node2D/AnimationPlayer"), "animation_finished")


func _on_voltar_pressed():
	if($option1/history1.get_text() == "Ouvir"):
		$AnimationPlayer.play_backwards("question2", -1)
		yield($AnimationPlayer, "animation_finished")
		_set_stories()
	else:
		$AnimationPlayer.play_backwards("transition", -1)
		yield($AnimationPlayer, "animation_finished")
		#warning-ignore:return_value_discarded
		get_tree().change_scene_to(previous_scene)


func _on_musicButton_pressed():
	if(global_config.music == true):
		global_config.music_off()
		$musicButton.set_texture(musicOff)
	else:
		global_config.music_on()
		$musicButton.set_texture(musicOn)


func _set_stories():
	print(global_config.stories.size())
	if(global_config.stories.size()==1):
		$option1/history1.set_text(global_config.stories["Story_1"]["Story_title"])
		global_config.best_fit_check(50, $option1/history1)
		$option2/history2.set_text("")
		$option2/history2Button.set_block_signals(true)
		$option3/history3.set_text("")
		$option3/history3Button.set_block_signals(true)
		$option3.set_visible(false)
	elif(global_config.stories.size()==2):
		$option1/history1.set_text(global_config.stories["Story_1"]["Story_title"])
		global_config.best_fit_check(50, $option1/history1)
		$option2/history2.set_text(global_config.stories["Story_2"]["Story_title"])
		global_config.best_fit_check(50, $option2/history2)
		$option3/history3.set_text("")
		$option3/history3Button.set_block_signals(true)
		$option3.set_visible(false)
	else:
		$option1/history1.set_text(global_config.stories["Story_1"]["Story_title"])
		global_config.best_fit_check(50, $option1/history1)
		$option2/history2.set_text(global_config.stories["Story_2"]["Story_title"])
		global_config.best_fit_check(50, $option2/history2)
		$option3/history3.set_text(global_config.stories["Story_3"]["Story_title"])
		global_config.best_fit_check(50, $option3/history3)


func _on_history1Button_pressed():
	if($option1/history1.get_text() == "Ouvir"):
		global_config.mode = 1
		#warning-ignore:return_value_discarded
		get_tree().change_scene_to(listenStory)
	else:
		global_config.storychosen = 1
		select_screen()


func _on_history2Button_pressed():
	print("oi")
	if($option2/history2.get_text() == "Ler"):
		global_config.mode = 2
		#warning-ignore:return_value_discarded
		get_tree().change_scene_to(readStory)
	else:
		global_config.storychosen = 2
		select_screen()


func _on_history3Button_pressed():
	global_config.storychosen = 3
	select_screen()


func select_screen():
	#Tem texto e não tem som
	if(global_config.stories["Story_" + str(global_config.storychosen)]["Story_sound_path"].empty() && !global_config.stories["Story_"  + str(global_config.storychosen)]["Story_text_description"].empty()):
		global_config.mode = 2
		get_node("/root/Node2D/AnimationPlayer").play_backwards("transition", -1)
		yield(get_node("/root/Node2D/AnimationPlayer"), "animation_finished")
		#warning-ignore:return_value_discarded
		get_tree().change_scene_to(readStory)
	#Tem som e não tem texto
	elif(!global_config.stories["Story_" + str(global_config.storychosen)]["Story_sound_path"].empty() && global_config.stories["Story_"  + str(global_config.storychosen)]["Story_text_description"].empty()):
		global_config.mode = 1
		get_node("/root/Node2D/AnimationPlayer").play_backwards("transition", -1)
		yield(get_node("/root/Node2D/AnimationPlayer"), "animation_finished")
		#warning-ignore:return_value_discarded
		get_tree().change_scene_to(listenStory)
	#Tem texto e som
	elif(!global_config.stories["Story_" + str(global_config.storychosen)]["Story_sound_path"].empty() && !global_config.stories["Story_"  + str(global_config.storychosen)]["Story_text_description"].empty()):
		$AnimationPlayer.play("question2", -1, 1.0, false)
		$option2/history2Button.set_block_signals(false)
		yield($AnimationPlayer, "animation_finished")
	#Não tem texto nem som
	else:
		global_config.mode = 3
		if(global_config.img[global_config.storychosen-1] == false):
			#warning-ignore:return_value_discarded
			get_tree().change_scene_to(next_scene2)
		else:
			#warning-ignore:return_value_discarded
			get_tree().change_scene_to(next_scene)