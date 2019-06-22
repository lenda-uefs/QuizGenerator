extends Node2D

var next_scene = preload("res://screens/gameScene/game.tscn")
var next_scene2 = preload("res://screens/gameScene2/game2.tscn")
var previous_scene = load("res://screens/chooseStoryScene/storyChoose.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Bluebackground.set_frame_color(Color(global_config.game_color["r"], global_config.game_color["g"], global_config.game_color["b"]))
	$title.set_text(global_config.stories["Story_" + str(global_config.storychosen)]["Story_title"])
	global_config.best_fit_check(100, $title)
	$storyText.set_text(global_config.stories["Story_" + str(global_config.storychosen)]["Story_text_description"])
	$book.set_texture(global_config.stories["Story_" + str(global_config.storychosen)]["Story_cover"])
	$AnimationPlayer.play("transition3", -1, 1.0, false)
	yield($AnimationPlayer, "animation_finished")


func _on_voltar_pressed():
	get_node("/root/Node2D/AnimationPlayer").play_backwards("transition3", -1)
	yield(get_node("/root/Node2D/AnimationPlayer"), "animation_finished")
	#warning-ignore:return_value_discarded
	get_tree().change_scene_to(previous_scene)


func _on_iniciarJogo_pressed():
	if(global_config.music==true):
		if(global_config.background_sound.is_playing() == false):
			global_config.music_on()
	if(global_config.img == false):
			#warning-ignore:return_value_discarded
			get_tree().change_scene_to(next_scene2)
	else:
			#warning-ignore:return_value_discarded
			get_tree().change_scene_to(next_scene)