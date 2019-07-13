extends Node2D

var correctAnswer
var givenAnswer = 3
var questionNumber = 1
var win_scene = preload("res://screens/winScene/winScreen.tscn")


func _ready():
	$BlueBackground.set_frame_color(Color(global_config.game_color["r"], global_config.game_color["g"], global_config.game_color["b"]))
	#warning-ignore:return_value_discarded
	get_tree().set_auto_accept_quit(false)
	get_tree().set_quit_on_go_back(false)
	if(global_config.mode == 1):
		$Popup1/title.set_text(global_config.stories["Story_" + str(global_config.storychosen)]["Story_title"])
		global_config.best_fit_check(35, $Popup1/title)
	elif(global_config.mode == 2):
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
		$ColorRect2/Label.set_text("Para responder, basta clicar na alternativa\n que julga ser correta. Vamos lá, tente!")
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
			$AnimationPlayer.play("wrong", -1, 1.0, false)
			yield($AnimationPlayer, "animation_finished")
			#sugerir que a história seja ouvida novamente
			#Faz com que não seja possível clicar nos botões:
			$alternativa1Button.set_block_signals(true)
			$alternativa2Button.set_block_signals(true)
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
	var alternativaTexts
	if(global_config.storytelling == false):
		questionText = global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(global_config.level+1)]["question_text"]
		alternativaTexts = ["a) " + global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(global_config.level+1)]["option_1"]["text"], "b) " + global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(global_config.level+1)]["option_2"]["text"]]
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
			if(global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(number)].size() == 4):
				alternativaTexts = ["a) " + global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(number)]["option_1"]["text"], "b) " + global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(number)]["option_2"]["text"]]
			else:
				alternativaTexts = ["a) " + global_config.stories["Story_" + str(global_config.storychosen)]["Questions"]["Question_" + str(number)]["option_1"]["text"], ""]
	if(global_config.finish != 1):
		$question.set_text(str(questionNumber) + questionText)
		global_config.best_fit_check(50, $question)
		$alternativa1.set_text(alternativaTexts[0])
		global_config.best_fit_check($question.get("custom_fonts/font/size"), $alternativa1)
		if(!alternativaTexts[1].empty()):
			$alternativa2.set_text(alternativaTexts[1])
			global_config.best_fit_check($question.get("custom_fonts/font/size"), $alternativa2)
			$alternativa2Button.set_block_signals(false)
		else:
			$alternativa2Button.set_block_signals(true)
			$alternativa2.set_text("")
		questionNumber = questionNumber + 1


func _on_pause_pressed():
	$pauseScreen/close.set_block_signals(false)
	$pauseScreen.set_visible(true)
	$alternativa1Button.set_block_signals(true)
	$alternativa2Button.set_block_signals(true)
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
	$alternativa1Button.set_block_signals(false)
	$alternativa2Button.set_block_signals(false)
	$pause.set_block_signals(false)


func _on_alternativa1Button_pressed():
	givenAnswer = 1
	next()


func _on_alternativa2Button_pressed():
	givenAnswer = 2
	next()