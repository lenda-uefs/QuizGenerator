extends Node2D

var instructionNumber = 0
var textos = ["- Ao escolher Jogar, você será levado a essa tela.",
"- No lado direito, você possui opções de história para jogar. \n Escolha uma.",
"- Você deverá ouvir a história escolhida no mínimo uma vez.",
"- Após ouvi-la, deverá clicar em Iniciar Jogo.",
"- Essa é a tela de jogo.", 
"- Caso queira visualizar uma polaroid mais de perto, clique \n uma vez nela.",
"- Caso deseje selecionar uma resposta, deslize para baixo, \n como mostrado na imagem.",
"- Caso você erre a resposta, será sugerido que você ouça a \n história novamente.",
"- Quando terminar o jogo, você será levado para essa tela, \n onde poderá escolher jogar novamente ou voltar ao menu."]

var images = [preload("res://sprites/images/EscolherHist.png"),
preload("res://sprites/images/opcoesHist.png"),
preload("res://sprites/images/playingHist.png"),
preload("res://sprites/images/iniciarJogo.png"),
preload("res://sprites/images/TelaJogo.png"),
preload("res://sprites/images/picZoom.png"),
preload("res://sprites/images/answer.png"),
preload("res://sprites/images/wrongAnswer.png"),
preload("res://sprites/images/winScreen.png")]


var images_sizes = [Vector2(0.709,0.709), 
Vector2(0.709,0.709), 
Vector2(0.709,0.67),
Vector2(0.709,0.67),
Vector2(0.709,0.67),
Vector2(0.709,0.709),
Vector2(0.709,0.709),
Vector2(0.709,0.709),
Vector2(0.709,0.709),
Vector2(0.709,0.709)]

var titleScreen = preload("res://screens/titleScreen/titleScreen.tscn")
var game_scene = preload("res://screens/gameScene/game.tscn")

var musicOff = preload("res://sprites/images/soundOff.png")
var musicOn = preload("res://sprites/images/soundOn.png")

func _ready():
	pass # Replace with function body.


func _on_next_pressed():
	instructionNumber = instructionNumber + 1
	if(global_config.music == true):
		$musicButton.set_texture(musicOn)
	else:
		$musicButton.set_texture(musicOff)
	if(instructionNumber == 9):
		$next.set_visible(false)
		global_config.played_once = 1
		global_config.save_game()
		if(global_config.comeFrom_listenHistory == 1):
			global_config.comeFrom_listenHistory = 0
			$Popup.popup()
	$previous.set_visible(true)
	_putImage()

func _on_previous_pressed():
	instructionNumber = instructionNumber - 1
	if(instructionNumber == 0):
		$previous.set_visible(false)
	$next.set_visible(true)
	_putImage()


func _putImage():
	$tela1.set_texture(images[instructionNumber])
	$tela1.set_scale(images_sizes[instructionNumber])
	$Label.set_text(textos[instructionNumber])
	match(instructionNumber):
		1:
			$arrow.set_visible(true)
			$AnimationPlayer.play("arrowBlinking", -1, 1.0, false)
		2:
			$AnimationPlayer.stop(true)
			$arrow.set_visible(false)
			$innerClick.set_visible(false)
			$outerClick.set_visible(false)
			$click.set_visible(false)
		4:
			$outerClick.set_visible(true)
			$innerClick.set_visible(true)
			$click.set_visible(true)
			$AnimationPlayer.play("clickEmulator1", -1, 1.0, false)
		5:
			$AnimationPlayer.stop(true)
			$outerClick.set_visible(false)
			$innerClick.set_visible(false)
			$click.set_visible(false)
			$polaroid1.set_visible(false)
			$pin.set_visible(false)
		6:
			$outerClick.set_visible(true)
			$innerClick.set_visible(true)
			$click.set_visible(true)
			$polaroid1.set_visible(true)
			$pin.set_visible(true)
			$AnimationPlayer.play("clickEmulator2", -1, 1.0, false)
		7:
			$AnimationPlayer.stop()
			$outerClick.set_visible(false)
			$innerClick.set_visible(false)
			$click.set_visible(true)
			$polaroid1.set_visible(true)
			$pin.set_visible(true)
			$AnimationPlayer.play("slideEmulator", -1, 1.0, false)
		8:
			$AnimationPlayer.stop()
			$click.set_visible(false)
			$polaroid1.set_visible(false)
			$pin.set_visible(false)
		9:
			pass

func _on_back_pressed():
	#warning-ignore:return_value_discarded
	get_tree().change_scene_to(titleScreen)


func _on_iniciarJogo_pressed():
	#warning-ignore:return_value_discarded
	get_tree().change_scene_to(game_scene)


func _on_musicButton_pressed():
	if(global_config.music == true):
		global_config.music_off()
		$musicButton.set_texture(musicOff)
	else:
		global_config.music_on()
		$musicButton.set_texture(musicOn)