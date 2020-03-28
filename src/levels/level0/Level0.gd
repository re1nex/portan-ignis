extends Node2D

var posRD = Vector2()
var posLU = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	posRD = $Level0Landscape.posRD
	posLU = $Level0Landscape.posLU
	$Player.prepare_camera(posLU, posRD)
	$IgnisRegularOuter.connect("ignis_regular_taken", $Player, "_on_IgnisRegularOuter_ignis_regular_taken")
	$CanvasLayer/HUD.init_player($Player)
	$Player.connect("die", self, "_on_Player_die")
	$WindowGameOver/MarginContainer.hide()
	$WinWindow/MarginContainer.hide()


func _on_Player_die():
	#$Player.queue_free()
	get_tree().paused = true
	$WindowGameOver._closeBefore()
	$WindowGameOver/MarginContainer.show()
	pass # Replace with function body.
