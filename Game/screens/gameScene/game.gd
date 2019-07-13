extends Node2D

var correctAnswer
var givenAnswer = 3
var win_scene = preload("res://screens/winScene/winScreen.tscn")
#Essas variáveis armazenam o valor "1" caso estejam pressionados e "0" caso não estejam pressionados
var button1_1 = 0
var button1_2 = 0
var button2_1 = 0
var button2_2 = 0


func _ready():
	$BlueBackground.set_frame_color(Color(global_config.game_color["r"], global_config.game_color["g"], global_config.game_color["b"]))
#warning-ignore:return_value_discarded
	$optionsAnimation/close.set_block_signals(true)
	get_tree().set_auto_accept_quit(false)
	get_tree().set_quit_on_go_back(false)
	if(global_config.mode == 1):
		$Popup1/title.set_text(global_config.stories["Story_" + str(global_config.storychosen)]["Story_title"])
		global_config.best_fit_check(35, $Popup1/title)
	else:
		$Popup2/title.set_text(global_config.stories["Story_" + str(global_config.storychosen)]["Story_title"])
		global_config.best_fit_check(35, $Popup2/title)
		$Popup2/text.set_text(global_config.stories["Story_" + str(global_config.storychosen)]["Story_text_description"])
	if(global_config.storytelling == true):
		global_config.level = 1
	_set_options()
	if(global_config.played_once == 0):
		$ColorRect2.set_visible(true)
		$ColorRect2/Label.set_text("Olá, bem vindo(a)! Como é sua primeira vez aqui, vou te \n ensinar como tudo funciona.")
		$AnimationPlayer.play("tip2", -1, 1.0, false)
		yield(get_tree().create_timer(4), "timeout")
		$ColorRect2/Label.set_text("Para dar zoom, dê um clique na polaroid. Vamos lá, tente!")
		$AnimationPlayer.play("tip", -1, 1.0, false)
		yield($AnimationPlayer, "animation_finished")
		$outerClick.set_visible(true)
		$innerClick.set_visible(true)
		$click.set_visible(true)
		$AnimationPlayer.play("zoomClick2", -1, 1.0, false)


func next():
	if(global_config.storytelling == false):
		if(givenAnswer == correctAnswer):
			global_config.increment_level()
			if(global_config.finish !=1):
				_set_options()
			else:
			#warning-ignore:return_value_discarded
				get_tree().change_scene_to(win_scene)
				global_config.played_once = 1
				global_config.save_game()
		else:
			if(givenAnswer == 1):
				get_node("/root/Node2D/optionsAnimation/AnimationPlayer").play_backwards("answer_Option1", -1)
				yield(get_node("/root/Node2D/optionsAnimation/AnimationPlayer"), "animation_finished")
			else:
				get_node("/root/Node2D/optionsAnimation/AnimationPlayer").play_backwards("answer_Option2", -1)
				yield(get_node("/root/Node2D/optionsAnimation/AnimationPlayer"), "animation_finished")
			$optionsAnimation.set_visible(false)
			#sugerir que a história seja ouvida novamente
			#Faz com que não seja possível clicar nos botões:
			$polaroid3/half1_1.set_block_signals(true)
			$polaroid3/half1_2.set_block_signals(true)
			$polaroid3_2/half2_1.set_block_signals(true)
			$polaroid3_2/half2_2.set_block_signals(true)
			$pause.set_block_signals(true)
			$wrongAnswer.set_visible(true)
			if(global_config.mode != 3):
				$wrongAnswer/opt1/ouvirAgain.set_block_signals(false)
			else:
				$wrongAnswer/opt1/ouvirAgain.set_block_signals(true)
				$wrongAnswer/opt1/ouvirAgain.set_visible(false)
				$wrongAnswer/Label2.set_visible(false)
			$wrongAnswer/opt2/keepPlaying.set_block_signals(false)
			get_node("/root/Node2D/wrongAnswer/AnimationPlayer").play("openUp", -1, 1.0, false)
			yield(get_node("/root/Node2D/wrongAnswer/AnimationPlayer"), "animation_finished")
	else:
		_set_options()
	if(global_config.played_once == 0):
		$AnimationPlayer.stop()
		$click.set_visible(false)
		global_config.played_once=1
		global_config.save_game()
		$ColorRect2/Label.set_text("Agora você está pronto para continuar a brincar sozinho. \n Boa sorte!")
		yield(get_tree().create_timer(3), "timeout")
		$AnimationPlayer.play_backwards("tip", -1)
		yield($AnimationPlayer, "animation_finished")


func _set_options():
	var questionText
	var polaroidTexture
	var labelPolaroid
	if(global_config.storytelling == false):
		questionText = global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(global_config.level+1)]["question_text"]
		polaroidTexture = [global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(global_config.level+1)]["option_1"]["image"], global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(global_config.level+1)]["option_2"]["image"]]
		labelPolaroid = [global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(global_config.level+1)]["option_1"]["text"], global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(global_config.level+1)]["option_2"]["text"]]
		correctAnswer = int(global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(global_config.level+1)]["answer"])
	else:
		var number
		if(givenAnswer == 3):
			number = 1
		else:
			if(global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(global_config.level)]["option_" + str(givenAnswer)]["goTo"] != "end"):
				number = global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(global_config.level)]["option_" + str(givenAnswer)]["goTo"]
				number.erase(0,number.find_last("_")+1)
				number = int(number)
				global_config.level = number
			else:
				number = 0
				global_config.save_game()
				global_config.played_once = 1
				global_config.finish = 1
				#warning-ignore:return_value_discarded
				get_tree().change_scene_to(win_scene)
		if(number!=0):
			questionText = global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(number)]["question_text"]
			if(global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(number)].size()):
				polaroidTexture = [global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(number)]["option_1"]["image"], global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(number)]["option_2"]["image"]]
				labelPolaroid = [global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(number)]["option_1"]["text"], global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(number)]["option_2"]["text"]]
			else:
				polaroidTexture = [global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(number)]["option_1"]["image"], ""]
				labelPolaroid = [global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(number)]["option_1"]["text"], ""]
	if(global_config.finish!=1):
		$question.set_text(questionText)
		global_config.best_fit_check(40, $question)
		$polaroid3/polaroid1.set_texture(polaroidTexture[0])
		$labelPolaroid1.set_text(labelPolaroid[0])
		global_config.best_fit_check(30, $labelPolaroid1)
		if(!labelPolaroid[1].empty()):
			$polaroid3_2/polaroid1.set_texture(polaroidTexture[1])
			$labelPolaroid2.set_text(labelPolaroid[1])
			global_config.best_fit_check(30, $labelPolaroid2)
			if($labelPolaroid1.get("custom_fonts/font/size") < $labelPolaroid2.get("custom_fonts/font/size")):
				$labelPolaroid2.get("custom_fonts/font").set("size", $labelPolaroid1.get("custom_fonts/font/size"))
			else:
				$labelPolaroid1.get("custom_fonts/font").set("size", $labelPolaroid2.get("custom_fonts/font/size"))


func _zoomScreenAnimation(var type):
	if(global_config.played_once == 0):
		$AnimationPlayer.stop()
		$outerClick.set_visible(false)
		$innerClick.set_visible(false)
		$click.set_visible(false)
		$ColorRect2/Label.set_text("Para fechar, clique no X acima")
	#Faz com que não seja possível clicar nos botões:
	$polaroid3/half1_1.set_block_signals(true)
	$polaroid3/half1_2.set_block_signals(true)
	$polaroid3_2/half2_1.set_block_signals(true)
	$polaroid3_2/half2_2.set_block_signals(true)
	$optionsAnimation/close.set_block_signals(false)
	if(type == 0):
		$optionsAnimation/TouchScreenButton.set_texture($polaroid3/polaroid1.get_texture())
		$optionsAnimation/Label.set_text($labelPolaroid1.get_text())
		global_config.best_fit_check(30, $optionsAnimation/Label)
		$optionsAnimation.set_visible(true)
		get_node("/root/Node2D/optionsAnimation/AnimationPlayer").play("zoom_in_Option1", -1, 1.0, false)
		yield(get_node("/root/Node2D/optionsAnimation/AnimationPlayer"), "animation_finished")
		global_config.zoomPic = 0
	else:
		$optionsAnimation/TouchScreenButton.set_texture($polaroid3_2/polaroid1.get_texture())
		$optionsAnimation/Label.set_text($labelPolaroid2.get_text())
		global_config.best_fit_check(30, $optionsAnimation/Label)
		$optionsAnimation.set_visible(true)
		get_node("/root/Node2D/optionsAnimation/AnimationPlayer").play("zoom_in_Option2", -1, 1.0, false)
		yield(get_node("/root/Node2D/optionsAnimation/AnimationPlayer"), "animation_finished")
		global_config.zoomPic = 1
	global_config.best_fit_check(50, $optionsAnimation/Label)


func _on_half1_1_pressed():
	button1_1 = 1
	_verifyButtonsOption0()


func _on_half1_2_pressed():
	button1_2 = 1
	if(button1_1 != 1):
		_verifyButtonsOption0()


func _on_half2_1_pressed():
	button2_1 = 1
	_verifyButtonsOption1()


func _on_half2_2_pressed():
	button2_2 = 1
	if(button2_1 != 1):
		_verifyButtonsOption1()


func _verifyButtonsOption0():
	yield(get_tree().create_timer(0.2), "timeout")
	if(button1_1 == 1 and button1_2 == 1):
		$optionsAnimation/TouchScreenButton.set_texture($polaroid3/polaroid1.get_texture())
		$optionsAnimation/Label.set_text($labelPolaroid1.get_text())
		global_config.best_fit_check(30, $optionsAnimation/Label)
		$optionsAnimation.set_visible(true)
		#$polaroid3/polaroid1.set_visible(false)
		get_node("/root/Node2D/optionsAnimation/AnimationPlayer").play("answer_Option1", -1, 1.0, false)
		yield(get_node("/root/Node2D/optionsAnimation/AnimationPlayer"), "animation_finished")
		givenAnswer = 1
		next()
	else:
		$pauseScreen/close.set_block_signals(true)
		$pause.set_block_signals(true)
		$optionsAnimation/close.set_block_signals(false)
		_zoomScreenAnimation(0)
	button1_1 = 0
	button1_2 = 0


func _verifyButtonsOption1():
	yield(get_tree().create_timer(0.2), "timeout")
	if(button2_1 == 1 and button2_2 == 1):
		$optionsAnimation/TouchScreenButton.set_texture($polaroid3_2/polaroid1.get_texture())
		$optionsAnimation/Label.set_text($labelPolaroid2.get_text())
		global_config.best_fit_check(30, $optionsAnimation/Label)
		$optionsAnimation.set_visible(true)
		#$polaroid3_2/polaroid1.set_visible(false)
		get_node("/root/Node2D/optionsAnimation/AnimationPlayer").play("answer_Option2", -1, 1.0, false)
		yield(get_node("/root/Node2D/optionsAnimation/AnimationPlayer"), "animation_finished")
		givenAnswer = 2
		next()
	else:
		$pauseScreen/close.set_block_signals(true)
		$pause.set_block_signals(true)
		$optionsAnimation/close.set_block_signals(false)
		_zoomScreenAnimation(1)
	button2_1 = 0
	button2_2 = 0


func _on_pause_pressed():
	$pauseScreen/close.set_block_signals(false)
	$pauseScreen.set_visible(true)
	$polaroid3/half1_1.set_block_signals(true)
	$polaroid3/half1_2.set_block_signals(true)
	$polaroid3_2/half2_1.set_block_signals(true)
	$polaroid3_2/half2_2.set_block_signals(true)
	$pause.set_block_signals(true)
	if(global_config.played_once == 0):
		$innerClick.set_visible(false)
		$outerClick.set_visible(false)
		$click.set_visible(false)
		$ColorRect2.set_visible(false)
	$pauseScreen/AnimationPlayer.play_backwards("Pausemenu", -1)
	yield(get_node("/root/Node2D/pauseScreen/AnimationPlayer"), "animation_finished")


func _on_keepPlaying_pressed():
	$Popup2.set_visible(false)
	$polaroid3/half1_1.set_block_signals(false)
	$polaroid3/half1_2.set_block_signals(false)
	$polaroid3_2/half2_1.set_block_signals(false)
	$polaroid3_2/half2_2.set_block_signals(false)
	$pause.set_block_signals(false)