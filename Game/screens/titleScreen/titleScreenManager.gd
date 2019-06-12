extends Node2D

var storyChose_scene = load("res://screens/chooseStoryScene/storyChoose.tscn")
var instruction_scene = load("res://screens/instructions/instructions.tscn")
var musicOff = preload("res://sprites/images/soundOff.png")
var musicOn = preload("res://sprites/images/soundOn.png")


func _ready():
	$gameTitle.set_text(global_config.game_title)
	global_config.best_fit_check(48, $gameTitle)
	$goBack/voltar.set_block_signals(true)
	get_tree().set_quit_on_go_back(true)
	get_tree().set_auto_accept_quit(true)
	if(global_config.music == true):
		$musicButton.set_texture(musicOn)
	else:
		$musicButton.set_texture(musicOff)
	get_node("/root/Node2D/AnimationPlayer").play_backwards("transition", -1)
	yield(get_node("/root/Node2D/AnimationPlayer"), "animation_finished")


func _on_play_pressed():
	$option1/play.set_shape_visible(false)
	$instructions.set_shape_visible(false)
	$option3/creditos.set_shape_visible(false)
	get_node("/root/Node2D/AnimationPlayer").play("transition", -1, 1.0, false)
	yield(get_node("/root/Node2D/AnimationPlayer"), "animation_finished")
#warning-ignore:return_value_discarded
	get_tree().change_scene_to(storyChose_scene)


func _on_instructions_pressed():
	get_node("/root/Node2D/AnimationPlayer").play("transition", -1, 1.0, false)
	yield(get_node("/root/Node2D/AnimationPlayer"), "animation_finished")
	#warning-ignore:return_value_discarded
	get_tree().change_scene_to(instruction_scene)


func _on_creditos_pressed():
	$creditos.set_visible(true)
	$logo2.set_visible(true)
	$goBack.set_visible(true)
	get_node("/root/Node2D/AnimationPlayer").play("creditScreen", -1, 1.0, false)
	yield(get_node("/root/Node2D/AnimationPlayer"), "animation_finished")
	$goBack/voltar.set_block_signals(false)
	$option1/play.set_block_signals(true)
	$instructions.set_block_signals(true)
	$option3/creditos.set_block_signals(true)


func _on_voltar_pressed():
	get_node("/root/Node2D/AnimationPlayer").play_backwards("creditScreen", -1)
	yield(get_node("/root/Node2D/AnimationPlayer"), "animation_finished")
	$creditos.set_visible(false)
	$logo2.set_visible(false)
	$goBack.set_visible(false)
	$option1/play.set_block_signals(false)
	$instructions.set_block_signals(false)
	$option3/creditos.set_block_signals(false)
	$goBack/voltar.set_block_signals(true)


func _on_musicButton_pressed():
	if(global_config.music == true):
		global_config.music_off()
		$musicButton.set_texture(musicOff)
	else:
		global_config.music_on()
		$musicButton.set_texture(musicOn)