extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Level1Landscape/Ignises/IgnisHint.connect("active", $Hints/Hint5, "activate")
	$Level1Landscape/IgnisRegularOuter.connect("ignis_regular_taken", $Player, "_on_IgnisRegularOuter_ignis_regular_taken")
	$Level1Landscape/IgnisRegularOuter.connect("ignis_regular_taken", self, "_Hint_2")
	$Player.prepare_camera($Level1Landscape.posLU, $Level1Landscape.posRD)
	$Player.connect("die", self, "_on_Player_die")
	$Level1Landscape.connect("level_complete", self, "complete")
	$Menu/HUD.init_player($Player)
	$Hit.init_player($Player)
	$Inventory.set_player($Player)
	$Player.new_lvl()
	MusicController.playMusic(true)


func _on_Player_die():
	$PauseMenu.set_process_input(false)
	$Inventory.set_process_input(false)
	$Player.after_die()
	$WindowGameOver._closeBefore()
	$WindowGameOver.show()
	MusicController.playMusic(false)
	pass # Replace with function body.


func complete():
	$PauseMenu.set_process_input(false)
	$Inventory.set_process_input(false)
	$Player.goAway()
	$WinWindow.show()
	Transfer.copy_chars($Player)
	MusicController.playMusic(false)
	#get_tree().paused = true






func _on_Level1Landscape_player_stop():
	$Player.endLevel=true


func _on_Level1Landscape_hint_activate():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_Level1Landscape_hint_disactivate():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_Rocks_body_entered(body):
		$Player.hit()
		$Hints/Timer.connect("timeout", $Hints/Hint1, "activate")
		$Hints/Timer.start()
		$Areas/Rocks.queue_free()
		
func _Hint_2(type):
	$Hints/Timer.wait_time = 0.3
	$Hints/Timer.start()
	$Hints/Timer.connect("timeout", $Hints/Hint2, "activate")
	$Hints/Timer.disconnect("timeout", $Hints/Hint1, "activate")
	pass


func _on_Torch_body_entered(body):
	$Hints/Hint3.activate()
	$Areas/Torch.queue_free()


func _on_Torch2_body_entered(body):
	$Hints/Hint4.activate()
	$Areas/Torch2.queue_free()


func _on_Door_body_entered(body):
	$Hints/Hint6.activate()
	$Areas/Door.queue_free()
