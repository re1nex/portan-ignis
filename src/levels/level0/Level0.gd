extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	$Level0Landscape/IgnisRegularOuter.connect("ignis_regular_taken", $Player, "_on_IgnisRegularOuter_ignis_regular_taken")
	$Level0Landscape/Lever.connect("lever_taken", $Player, "_on_Lever_lever_taken")
	$Player.prepare_camera($Level0Landscape.posLU, $Level0Landscape.posRD)
	$Player.connect("die", self, "_on_Player_die")
	$Level0Landscape.connect("level_complete", self, "complete")
	$WinWindow/CenterContainer.hide()
	$Menu/HUD.init_player($Player)
	$Inventory.set_player($Player)
	$WindowGameOver/CenterContainer.hide()
	$Player.hit()
	$Player.new_lvl()
	MusicController.playMusic(true)


func _on_Player_die():
	$Player.after_die()
	$WindowGameOver._closeBefore()
	$WindowGameOver.show()
	MusicController.playMusic(false)
	pass # Replace with function body.
	
func complete():
	$Player.goAway()
	$WinWindow.show()
	Transfer.copy_chars($Player)
	MusicController.playMusic(false)
	#get_tree().paused = true






func _on_Level0Landscape_player_stop():
	$Player.endLevel=true
