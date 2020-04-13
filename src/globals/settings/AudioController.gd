extends Node


func changeVol(value):
	if(value==0):
		Settings.Sound["Mute"] = true
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
		return
	Settings.Sound["Mute"] = false
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	var dlt=(Settings.Sound["Volume"]-value)/2.5
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))- dlt)
	Settings.Sound["Volume"]=value


func turnVol(on):
	if(on):
		Settings.Sound["Mute"] = false
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
		Settings.Sound["Mute"] = true
