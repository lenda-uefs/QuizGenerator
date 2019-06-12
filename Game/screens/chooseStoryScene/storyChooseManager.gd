extends Node2D

var next_scene = preload("res://screens/listenStoryScene/listenHistory.tscn")
var previous_scene = load("res://screens/titleScreen/titleScreen.tscn")
var musicOff = preload("res://sprites/images/soundOff.png")
var musicOn = preload("res://sprites/images/soundOn.png")


func _ready():
	_set_stories()
	get_tree().set_auto_accept_quit(false)
	get_tree().set_quit_on_go_back(false)
	if(global_config.music == true):
		$musicButton.set_texture(musicOn)
	else:
		$musicButton.set_texture(musicOff)
	get_node("/root/Node2D/AnimationPlayer").play("transition", -1, 1.0, false)
	yield(get_node("/root/Node2D/AnimationPlayer"), "animation_finished")


func _set_buttons_invisible():
	$option1/tresPorquinhos.set_shape_visible(false)
	$option2/pequenaSereia.set_shape_visible(false)
	$chapeuzinhoVermelho.set_shape_visible(false)


func _on_voltar_pressed():
	get_node("/root/Node2D/AnimationPlayer").play_backwards("transition", -1)
	yield(get_node("/root/Node2D/AnimationPlayer"), "animation_finished")
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
		global_config.best_fit_check(29, $option1/history1)
		$option2/history2.set_text("")
		$option2/history2Button.set_block_signals(true)
		$option3/history3.set_text("")
		$option3/history3Button.set_block_signals(true)
		$option3.set_visible(false)
	elif(global_config.stories.size()==2):
		$option1/history1.set_text(global_config.stories["Story_1"]["Story_title"])
		global_config.best_fit_check(29, $option1/history1)
		$option2/history2.set_text(global_config.stories["Story_2"]["Story_title"])
		global_config.best_fit_check(29, $option2/history2)
		$option3/history3.set_text("")
		$option3/history3Button.set_block_signals(true)
		$option3.set_visible(false)
	else:
		$option1/history1.set_text(global_config.stories["Story_1"]["Story_title"])
		global_config.best_fit_check(29, $option1/history1)
		$option2/history2.set_text(global_config.stories["Story_2"]["Story_title"])
		global_config.best_fit_check(29, $option2/history2)
		$option3/history3.set_text(global_config.stories["Story_3"]["Story_title"])
		global_config.best_fit_check(29, $option3/history3)


func _on_history1Button_pressed():
	global_config.storychosen = 1
	get_node("/root/Node2D/AnimationPlayer").play_backwards("transition", -1)
	yield(get_node("/root/Node2D/AnimationPlayer"), "animation_finished")
	#warning-ignore:return_value_discarded
	get_tree().change_scene_to(next_scene)


func _on_history2Button_pressed():
	global_config.storychosen = 2
	get_node("/root/Node2D/AnimationPlayer").play_backwards("transition", -1)
	yield(get_node("/root/Node2D/AnimationPlayer"), "animation_finished")
	#warning-ignore:return_value_discarded
	get_tree().change_scene_to(next_scene)


func _on_history3Button_pressed():
	global_config.storychosen = 3
	get_node("/root/Node2D/AnimationPlayer").play_backwards("transition", -1)
	yield(get_node("/root/Node2D/AnimationPlayer"), "animation_finished")
	#warning-ignore:return_value_discarded
	get_tree().change_scene_to(next_scene)
