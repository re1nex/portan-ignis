extends Node2D

signal falls
signal win

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	$Player.prepare_camera($Level6Landscape.posLU, $Level6Landscape.posRD)
	
	$Ignises/IgnisDoor1.connect("active", $Level6Landscape/Doors/DoorOpen1, "_on_IgnisRegularLevel_active")
	$Ignises/IgnisDoor1.connect("not_active", $Level6Landscape/Doors/DoorOpen1, "_on_IgnisRegularLevel_not_active")
	
	$Ignises/IgnisDoor2.connect("active", $Level6Landscape/Doors/DoorOpen2, "_on_IgnisRegularLevel_active")
	$Ignises/IgnisDoor2.connect("not_active", $Level6Landscape/Doors/DoorOpen2, "_on_IgnisRegularLevel_not_active")
	
	
	$WinWindow/CenterContainer.hide()
	$HUD/HUD.init_player($Player)
	$Hit.init_player($Player)
	$WindowGameOver/CenterContainer.hide()
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


func _on_Win_body_entered(body):
	if body.has_method("get_informator"):
		$PauseMenu.set_process_input(false)
		$Inventory.set_process_input(false)
		$WinWindow.show()
		$Player.goAway()
		MusicController.playMusic(false)
		Transfer.copy_chars($Player)


func _on_End_body_entered(body):
	if body.has_method("get_informator"):
		$Player.endLevel=true


func _on_Level6Landscape_hint_activate():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_Level6Landscape_hint_disactivate():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
