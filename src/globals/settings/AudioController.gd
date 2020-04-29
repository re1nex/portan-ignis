extends Node



func changeVol(value):
	if(value==0):
		turnVol(false)
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
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
		Settings.Sound["Mute"] = true


func changeMusicVol(value):
	if(value==0):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
		return
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
	var dlt=(Settings.Sound["MusicVol"]-value)/4
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))- dlt)
	Settings.Sound["MusicVol"]=value
