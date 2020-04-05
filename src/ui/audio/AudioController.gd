extends Node
var sound=100
var mute =false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func changeVol(value):
	if(value==0):
		mute=true
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
		return
	mute=false
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	var dlt=(sound-value)/2.5
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))- dlt)
	sound=value
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func turnVol(on):
	if(on):
		mute=false
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
		mute=true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
