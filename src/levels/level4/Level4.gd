extends Node2D

signal falls
signal win

func _ready():
	$Player.prepare_camera($Level4Landscape.posLU, $Level4Landscape.posRD)
	
	$Ignises/IgnisDoor.connect("active", $Level4Landscape/Doors/Door3, "_on_IgnisRegularLevel_active")
	$Ignises/IgnisDoor.connect("not_active", $Level4Landscape/Doors/Door3, "_on_IgnisRegularLevel_not_active")
	
	$Ignises/IgnisDoor2.connect("active", $Level4Landscape/Doors/Door2, "_on_IgnisRegularLevel_active")
	$Ignises/IgnisDoor2.connect("not_active", $Level4Landscape/Doors/Door2, "_on_IgnisRegularLevel_not_active")

	$Objects/Mechanism.connect("active", $Level4Landscape/Doors/Door4, "_on_Mechanism_active")
	$Objects/Mechanism.connect("not_active", $Level4Landscape/Doors/Door4, "_on_Mechanism_not_active")
	
	$Ignises/IgnisActivated.activate_at_start()
	$Ignises/IgnisActivated2.activate_at_start()
	
	$Objects/Lever.connect("lever_taken", $Player, "_on_Lever_lever_taken")
	
	$WinWindow/CenterContainer.hide()
	$HUD/HUD.init_player($Player)
	$WindowGameOver/CenterContainer.hide()
	$Inventory.set_player($Player)
	$Player.new_lvl()
	MusicController.playMusic(true)



func _on_Player_die():
	#get_tree().paused = true
	$Player.after_die()
	$WindowGameOver._closeBefore()
	$WindowGameOver.show()
	MusicController.playMusic(false)


func _on_Win_body_entered(body):
	if body.has_method("get_informator"):
		$WinWindow.show()
		$Player.goAway()
		MusicController.playMusic(false)
		Transfer.copy_chars($Player)


func _on_End_body_entered(body):
	if body.has_method("get_informator"):
		$Player.endLevel=true
