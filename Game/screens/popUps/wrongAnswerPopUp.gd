extends Node2D

#var scenesTimes = [
#[0, 8.944, 20.581312, 24.906647, 29.087978, 36.27198, 46.863979, 50.954647, 55.301311, 64.826645, 75.813309, 81.461311, 89.034645, 94.287979],
#[0, 13.68, 21.6, 29.754667, 39.509335, 52.010666, 58.080002, 67.418663, 74.410667, 78.346649, 81.786644, 86.362648, 90.826645, 96.245316, 104.559982],
#[0, 6.133333, 10.362667, 23.440001, 30.154667, 40.469334, 43.674667, 50.762665, 56.015999, 66.842667, 76.767998, 89.984001]
#]

var buttons = [preload("res://sprites/images/goBack.png"), preload("res://sprites/images/play.png"),
preload("res://sprites/images/goForward.png")]

func _on_ouvirAgain_pressed():
	get_node("/root/Node2D/wrongAnswer/AnimationPlayer").play_backwards("openUp", -1)
	yield(get_node("/root/Node2D/wrongAnswer/AnimationPlayer"), "animation_finished")
	get_node("/root/Node2D/wrongAnswer").set_visible(false)
	if(global_config.mode == 1):
		get_node("/root/Node2D/Popup1").popup()
		get_node("/root/Node2D/Popup1/history/goBack").set_texture(buttons[0])
		get_node("/root/Node2D/Popup1/history/play").set_texture(buttons[1])
		get_node("/root/Node2D/Popup1/history/goForward").set_texture(buttons[2])
		get_node("/root/Node2D/Popup1/history/timePassing").set_visible(true)
		get_node("/root/Node2D/Popup1/history/playerExibition").set_visible(true)
		get_node("/root/Node2D/Popup1/history/goBack").set_block_signals(false)
		get_node("/root/Node2D/Popup1/history/play").set_block_signals(false)
		get_node("/root/Node2D/Popup1/history/goForward").set_block_signals(false)
		get_node("/root/Node2D/Popup1/history/keepPlaying").set_block_signals(false)
		get_node("/root/Node2D/Popup1/history").setAudioTime(0)
	else:
		get_node("/root/Node2D/Popup2").popup()
	#get_node("/root/Node2D/Popup/history").setAudioTime(scenesTimes[global_config.storychosen-1][global_config.level])


func _on_keepPlaying_pressed():
	$opt1/ouvirAgain.set_block_signals(true)
	$opt2/keepPlaying.set_block_signals(true)
	get_node("/root/Node2D/wrongAnswer/AnimationPlayer").play_backwards("openUp", -1)
	yield(get_node("/root/Node2D/wrongAnswer/AnimationPlayer"), "animation_finished")
	get_node("/root/Node2D/wrongAnswer").set_visible(false)
	#Faz com que seja possível clicar nos botões:
	get_node("/root/Node2D/polaroid3/half1_1").set_block_signals(false)
	get_node("/root/Node2D/polaroid3/half1_2").set_block_signals(false)
	get_node("/root/Node2D/polaroid3_2/half2_1").set_block_signals(false)
	get_node("/root/Node2D/polaroid3_2/half2_2").set_block_signals(false)
	get_node("/root/Node2D/pause").set_block_signals(false)
