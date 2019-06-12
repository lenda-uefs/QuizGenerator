extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_close_pressed():
	if(global_config.zoomPic == 0):
		get_node("/root/Node2D/optionsAnimation/AnimationPlayer").play_backwards("zoom_in_Option1", -1)
	else:
		get_node("/root/Node2D/optionsAnimation/AnimationPlayer").play_backwards("zoom_in_Option2", -1)
	yield(get_node("/root/Node2D/optionsAnimation/AnimationPlayer"), "animation_finished")
	#Faz com que seja possível clicar nos botões:
	$close.set_block_signals(true)
	get_node("/root/Node2D/polaroid3/half1_1").set_block_signals(false)
	get_node("/root/Node2D/polaroid3/half1_2").set_block_signals(false)
	get_node("/root/Node2D/polaroid3_2/half2_1").set_block_signals(false)
	get_node("/root/Node2D/polaroid3_2/half2_2").set_block_signals(false)
	get_node("/root/Node2D/optionsAnimation").set_visible(false)
	$close.set_block_signals(true)
	get_node("/root/Node2D/pause").set_block_signals(false)
	if(global_config.played_once == 0):
		get_node("/root/Node2D/ColorRect2/Label").set_text("Para fornecer uma resposta, deslize para baixo. Tente!")
		get_node("/root/Node2D/click").set_visible(true)
		get_node("/root/Node2D/AnimationPlayer").play("slide", -1, 1.0, false)