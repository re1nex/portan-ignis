extends Node2D


func _ready():
	$Level1Landscape/IgnisRegularOuter.connect("ignis_regular_taken", $Player, "_on_IgnisRegularOuter_ignis_regular_taken")
	$Player.prepare_camera($Level1Landscape.posLU, $Level1Landscape.posRD)
	$Player.connect("die", self, "_on_Player_die")
	$Win/WinMenu/TextureButton.connect("pressed", self, "_on_Player_die")
	$Level1Landscape.connect("level_complete", self, "complete")
	$Win/WinMenu.hide()
	$Menu/HUD.init_player($Player)
	$WindowGameOver/MarginContainer.hide()
	
func _on_Player_die():
	get_tree().paused = true
	$WindowGameOver._closeBefore()
	$WindowGameOver/MarginContainer.show()
	pass # Replace with function body.
	
func complete():
	$Win/WinMenu.show()
	get_tree().paused = true
