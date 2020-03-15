extends Node2D


func _ready():
	$Level1Landscape/IgnisRegularOuter.connect("ignis_regular_taken", $Player, "_on_IgnisRegularOuter_ignis_regular_taken")
	$Player.prepare_camera($Level1Landscape.posLU, $Level1Landscape.posRD)
	$Player.connect("die", self, "_on_Player_die")
	$Win/WinMenu/TextureButton.connect("pressed", self, "_on_Player_die")
	$Level1Landscape.connect("level_complete", self, "complete")
	$Win/WinMenu.hide()
	
func _on_Player_die():
	#$Player.queue_free()
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_MAIN_MENU)
	get_tree().paused = false
	pass # Replace with function body.
	
func complete():
	$Win/WinMenu.show()
	get_tree().paused = true
