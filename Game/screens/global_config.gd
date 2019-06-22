extends Node

var level
var storychosen
var finish
var played_once
#warning-ignore:unused_class_variable
var zoomPic
var initiatingGame
var background_sound = AudioStreamPlayer.new()
var comeFrom_listenHistory
var music = true
var img = false

#warning-ignore:unused_class_variable
var mode #Caso seja 1, o jogo teve áudio. Caso seja 2, o jogo não teve

signal musicChanged

##########################     Configuráveis    #############################
var stories
#warning-ignore:unused_class_variable
var game_title
#warning-ignore:unused_class_variable
var game_color
#warning-ignore:unused_class_variable
var title_screen_background


func _ready():
	self.add_to_group("managers")


func loading_process_ended():
	level = 0
	finish = 0
	initiatingGame = 0
	comeFrom_listenHistory = 0
	load_game()
	playSong()
	music_on()


func increment_level():
	level = level+1
	if(level == stories["Story_" + str(storychosen)]["Questions"].size()):
		finish = 1


#Função para salvar os dados do jogo
func save_game():
	var arquivo = File.new()
	var erro = arquivo.open("user://save.data", File.WRITE)
	if not erro:
		arquivo.store_var(played_once)
	else:
		print("Erro ao salvar dados")
	arquivo.close()


#Função para carregar os dados do jogo
func load_game():
	var arquivo = File.new()
	var erro = arquivo.open("user://save.data", File.READ)
	if not erro:
		var dadosSalvos = arquivo.get_var()
		played_once = dadosSalvos
	else:
		played_once = 0
		print("Não foram encontrados dados referentes as instruções para serem carregados")
	arquivo.close()


#Liga a música do jogo
func music_on():
	music = true
	background_sound.play()
	emit_signal("musicChanged")


#Desliga a música do jogo
func music_off():
	music = false
	background_sound.stop()
	emit_signal("musicChanged")


#Função que seta as configurações da música que deve ser tocada na abertura do jogo
func playSong():
	if(!background_sound.is_inside_tree()):
		self.add_child(background_sound)
	#background_sound.stream = load("res://sound/Ukulele_Beach.ogg")
	background_sound.volume_db = -20


func best_fit_check(max_font_size, label):
	#print_debug("best_fit_check")
	var font = label.get("custom_fonts/font")
	if font == null:
		return
	font.set("size", max_font_size)
	var font_size = max_font_size
	#print_debug("best_fit_check " + str(label.get_visible_line_count()) + " " +
	#str(label.get_line_count()) )
	while label.get_visible_line_count() < label.get_line_count():
		font.set("size", font_size - 1)
		font_size = font.get("size")