extends Node2D

func _ready():
	$Level1Landscape/IgnisRegularOuter.connect("ignis_regular_taken", $Player, "_on_IgnisRegularOuter_ignis_regular_taken")
	$Player.prepare_camera($Level1Landscape.posLU, $Level1Landscape.posRD)
	$Player.connect("die", self, "_on_Player_die")
	$Level1Landscape.connect("level_complete", self, "complete")
	$WinWindow/CenterContainer.hide()
	$Menu/HUD.init_player($Player)
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






func _on_Level1Landscape_player_stop():
	$Player.endLevel=true
