extends Node2D

signal falls
signal win

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	$Characters/Player.prepare_camera($Level2Landscape.posLU, $Level2Landscape.posRD)
	connect("falls", self, "_on_Player_die")
	$Characters/Player.connect("die", self, "_on_Player_die")
	
	$Ignises/IgnisDoor2.connect("active", $Level2Landscape/Doors/Door2, "_on_IgnisRegularLevel_active")
	$Ignises/IgnisDoor2.connect("not_active", $Level2Landscape/Doors/Door2, "_on_IgnisRegularLevel_not_active")
	
	$Objects/Mechanism.connect("active", $Level2Landscape/Doors/Door3, "_on_Mechanism_active")
	$Objects/Mechanism.connect("not_active", $Level2Landscape/Doors/Door3, "_on_Mechanism_not_active")
	
	$Objects/Lever.connect("lever_taken", $Characters/Player, "_on_Lever_lever_taken")
	
	$Ignises/IgnisHint.connect("active", $Hints/Hint, "activate")
	$Ignises/IgnisHint2.connect("active", $Hints/Hint2, "activate")
	
	$HUD/HUD.init_player($Characters/Player)
	$Hit.init_player($Characters/Player)
	$Inventory.set_player($Characters/Player)
	$Characters/Player.new_lvl()
	MusicController.playMusic(true)


func _on_Player_die():
	#get_tree().paused = true
	$PauseMenu.set_process_input(false)
	$Inventory.set_process_input(false)
	$Characters/Player.after_die()
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
		$Characters/Player.goAway()
		Transfer.copy_chars($Characters/Player)


func _on_End_body_entered(body):
	if body.has_method("get_informator"):
		$Characters/Player.endLevel=true


func _on_Level2Landscape_hint_activate():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_Level2Landscape_hint_disactivate():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
