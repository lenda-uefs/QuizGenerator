extends Node2D

var initial_scene = load("res://screens/titleScreen/titleScreen.tscn")
var game_scene = load("res://screens/gameScene/game.tscn")

var musicOff = preload("res://sprites/images/soundOff.png")
var musicOn = preload("res://sprites/images/soundOn.png")


func _ready():
	get_tree().set_auto_accept_quit(false)
	get_tree().set_quit_on_go_back(false)
	if(global_config.music == true):
		$musicButton.set_texture(musicOn)
	else:
		$musicButton.set_texture(musicOff)
	get_node("/root/Node2D/AnimationPlayer").play("transition_winscene", -1, 1.0, false)
	yield(get_node("/root/Node2D/AnimationPlayer"), "animation_finished")


func _on_jogarNovamente_pressed():
	global_config.level=0
	global_config.finish=0
	_changeScene(game_scene)


func _on_menuInicial_pressed():
	_changeScene(initial_scene)


func _on_sair_pressed():
	get_tree().quit()


func _changeScene(scene):
	get_node("/root/Node2D/AnimationPlayer").play_backwards("transition_winscene", -1)
	yield(get_node("/root/Node2D/AnimationPlayer"), "animation_finished")
#warning-ignore:return_value_discarded
	get_tree().change_scene_to(scene)

func _on_musicButton_pressed():
	if(global_config.music == true):
		global_config.music_off()
		$musicButton.set_texture(musicOff)
	else:
		global_config.music_on()
		$musicButton.set_texture(musicOn)
