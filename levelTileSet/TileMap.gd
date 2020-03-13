extends Node2D

var posRD = Vector2()
var posLU = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	posRD = $Level/PositionRD.position
	posLU = $Level/PositionLU.position
	$Player.prepare_camera(posLU, posRD)
	$Player/Camera.zoom = Vector2(0.5, 0.5)
	$IgnisRegularOuter.connect("ignis_regular_taken", $Player, "_on_IgnisRegularOuter_ignis_regular_taken")


func _on_Player_die():
	$Player.queue_free()
	pass # Replace with function body.
