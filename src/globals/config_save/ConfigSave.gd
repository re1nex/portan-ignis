extends Node


const CONFIG_PATH = "user://config.cfg"
const KEY = "Petscop"
var conf = ConfigFile.new()


func _ready():
	var res = conf.load(CONFIG_PATH)
	# Шифровальная машина не работает
	#var res = conf.load_encrypted(CONFIG_PATH, KEY.to_ascii())
	
	if res == OK:
		read_from()


func save_to():
	conf.set_value("Sound", "MusicVol", Settings.Sound["MusicVol"])
	conf.set_value("Sound", "Volume", Settings.Sound["Volume"])
	conf.set_value("Sound", "Mute", Settings.Sound["Mute"])
	
	conf.set_value("Graphics", "Fullscreen", Settings.Graphics["Fullscreen"])
	conf.set_value("Graphics", "Stretching", Settings.Graphics["Stretching"])
	
	conf.save(CONFIG_PATH)
	# Шифровальная машина не работает
	#conf.save_encrypted(CONFIG_PATH, KEY.to_ascii())



func read_from():
	AudioController.changeMusicVol(conf.get_value("Sound", "MusicVol", Settings.Sound["MusicVol"]))
	AudioController.changeVol(conf.get_value("Sound", "Volume", Settings.Sound["Volume"]))
	AudioController.turnVol(!conf.get_value("Sound", "Mute", Settings.Sound["Mute"]))
		
	GraphicsController.set_fullscreen(conf.get_value("Graphics", "Fullscreen", Settings.Graphics["Fullscreen"]))
	GraphicsController.set_strecthing(conf.get_value("Graphics", "Stretching", Settings.Graphics["Stretching"]))


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_to()
