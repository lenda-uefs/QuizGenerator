extends Node2D

var next_scene = preload("res://screens/gameScene/game.tscn")
var previous_scene = load("res://screens/chooseStoryScene/storyChoose.tscn")

var musicOff = preload("res://sprites/images/soundOff.png")
var musicOn = preload("res://sprites/images/soundOn.png")



func _ready():
	if(global_config.music == true):
		$musicButton.set_texture(musicOn)
	else:
		$musicButton.set_texture(musicOff)
	global_config.level = 0
	$title.set_text(global_config.stories["Story_" + str(global_config.storychosen)]["Story_title"])
	global_config.best_fit_check(41, $title)
	$book.set_texture(global_config.stories["Story_" + str(global_config.storychosen)]["Story_cover"])
	get_tree().set_auto_accept_quit(false)
	get_tree().set_quit_on_go_back(false)
	get_node("/root/Node2D/AnimationPlayer").play("transition3", -1, 1.0, false)
	yield(get_node("/root/Node2D/AnimationPlayer"), "animation_finished")


func _on_iniciarJogo_pressed():
	if($history.listened_once == 1):
		if(global_config.music==true):
			if(global_config.background_sound.is_playing() == false):
				global_config.music_on()
		#warning-ignore:return_value_discarded
		get_tree().change_scene_to(next_scene)
	else:
		$Popup.popup()
		$Popup/ok.set_block_signals(false)
		$history._on_pause_pressed()


func _on_voltar_pressed():
	$history.stop()
	get_node("/root/Node2D/AnimationPlayer").play_backwards("transition3", -1)
	yield(get_node("/root/Node2D/AnimationPlayer"), "animation_finished")
	#warning-ignore:return_value_discarded
	get_tree().change_scene_to(previous_scene)


func _on_ok_pressed():
	$Popup.set_visible(false)
	$Popup/ok.set_block_signals(true)
	$history._on_play_pressed()


func _on_musicButton_pressed():
	if(global_config.music == true):
		global_config.music_off()
		$musicButton.set_texture(musicOff)
	else:
		global_config.music_on()
		$musicButton.set_texture(musicOn)