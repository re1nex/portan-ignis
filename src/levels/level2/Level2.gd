extends Node2D

signal falls
signal win

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	$Player.prepare_camera($Level2Landscape.posLU, $Level2Landscape.posRD)
	connect("falls", self, "_on_Player_die")
	$Player.connect("die", self, "_on_Player_die")
	
	$Ignises/IgnisDoor.connect("active", $Level2Landscape/Doors/Door2, "_on_IgnisRegularLevel_active")
	$Ignises/IgnisDoor.connect("not_active", $Level2Landscape/Doors/Door2, "_on_IgnisRegularLevel_not_active")
	$Ignises/IgnisDoor.activate_at_start()
	$Ignises/IgnisActivated.activate_at_start()
	
	$HUD/HUD.init_player($Player)
	$Hit.init_player($Player)
	$Inventory.set_player($Player)
	$Player.new_lvl()
	MusicController.playMusic(true)


func _on_Player_die():
	#get_tree().paused = true
	$PauseMenu.set_process_input(false)
	$Inventory.set_process_input(false)
	$Player.after_die()
	$WindowGameOver._closeBefore()
	$WindowGameOver.show()
	MusicController.playMusic(false)


func _on_Death_body_entered(body):
	if body.has_method("get_informator"):
		emit_signal("falls")
	elif body.has_method("check_chase"):
		$Enemy.queue_free()


func _on_Win_body_entered(body):
	if body.has_method("get_informator"):
		$PauseMenu.set_process_input(false)
		$Inventory.set_process_input(false)
		MusicController.playMusic(false)
		$WinWindow.show()
		$Player.goAway()
		Transfer.copy_chars($Player)


func _on_End_body_entered(body):
	if body.has_method("get_informator"):
		$Player.endLevel=true
