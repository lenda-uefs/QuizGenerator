extends AudioStreamPlayer

var pause_asset = preload("res://sprites/images/pause.png")
var play_asset = preload("res://sprites/images/play.png")
var increment
var pos = 0
var seg
var cena = 1
var listened_once = 0


func _ready():
	#warning-ignore:return_value_discarded
	$Timer.connect("timeout", self, "on_TimeOut")
	set_process(true)
	# history.volume_db = -20
	#8 até 335: total de 327 pixels
	if(global_config.mode == 1):
		var snd_file = File.new()
		snd_file.open(global_config.stories["Story_"+str(global_config.storychosen)]["Story_sound_path"], File.READ)
		var stream = AudioStreamOGGVorbis.new()
		stream.data = snd_file.get_buffer(snd_file.get_len())
		snd_file.close()
		self.stream = stream
		self.get_stream().set_loop(false) 
		increment = float(327)/float(self.get_stream().get_length())


#warning-ignore:unused_argument
func _process(delta):
	pos = self.get_playback_position()
	if(pos<60):
		if(pos<10):
			$timePassing.set_text("00:0" + str(int(pos)))
		else:
			$timePassing.set_text("00:" + str(int(pos)))
	else:
		seg = int(pos)%60
		if(seg<10):
			$timePassing.set_text("0" + str(int(pos/60)) + ":0" + str(seg))
		else:
			$timePassing.set_text("0" + str(int(pos/60)) + ":" + str(seg))


func _on_goBack_pressed():
	if(self.get_playback_position()>5):
		self.play(self.get_playback_position() - 5)
	else:
		self.play(0)
	$play.set_texture(pause_asset)


func _on_pause_pressed():
	$play.set_texture(play_asset)
	pos = self.get_playback_position()
	self.stop()
	if(global_config.music == true):
		global_config.background_sound.play()
	$Timer.stop()


func _on_play_pressed():
	global_config.background_sound.stop()
	if($play.get_texture() == play_asset):
		self.play(pos)
		$Timer.start()
		$play.set_texture(pause_asset)
	else:
		cena = cena + 1
		_on_pause_pressed()


func on_TimeOut():
	$playerExibition.set_size(Vector2(6+(increment*pos),17))


func audioFinished():
	listened_once = 1
	if(global_config.music==true):
		global_config.background_sound.play()
	$Timer.stop()
	$play.set_texture(play_asset)


func setAudioTime(var time):
	self.play(time)
	global_config.background_sound.stop()
	$Timer.start()
	$play.set_texture(pause_asset)


func _on_goForward_pressed():
	if(self.get_playback_position()<(self.get_stream().get_length()-5)):
		self.play(self.get_playback_position() + 5)
	else:
		self.play(self.get_stream().get_length()-1)
	$play.set_texture(pause_asset)


func _on_keepPlaying_pressed():
	if(global_config.music==true):
		global_config.music_on()
	$goBack.set_block_signals(true)
	$play.set_block_signals(true)
	$goForward.set_block_signals(true)
	$keepPlaying.set_block_signals(true)
	$goBack.set_texture(null)
	$goForward.set_texture(null)
	$play.set_texture(null)
	$timePassing.set_visible(false)
	$playerExibition.set_visible(false)
	$keepPlaying.set_texture(null)
	self.stop()
	get_node("/root/Node2D/Popup1").set_visible(false)
	if(global_config.img[global_config.storychosen-1] == true):
		get_node("/root/Node2D/polaroid3/half1_1").set_block_signals(false)
		get_node("/root/Node2D/polaroid3/half1_2").set_block_signals(false)
		get_node("/root/Node2D/polaroid3_2/half2_1").set_block_signals(false)
		get_node("/root/Node2D/polaroid3_2/half2_2").set_block_signals(false)
	else:
		get_node("/root/Node2D/alternativa1Button").set_block_signals(false)
		get_node("/root/Node2D/alternativa2Button").set_block_signals(false)
	get_node("/root/Node2D/pause").set_block_signals(false)