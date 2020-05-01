extends Node2D

var posRD
var posLU

signal level_complete
signal player_stop

func _ready():
	posRD = $PositionRD.position
	posLU = $PositionLU.position
	
	$CanvasModulate.visible = false
	
	$Ignises/IgnisDoor.connect("active", $Door, "_on_IgnisRegularLevel_active")
	$Ignises/IgnisDoor.connect("not_active", $Door, "_on_IgnisRegularLevel_not_active")
	$Hint.activate()
	pass


func _on_LevelEnd_body_entered(body):
	if body.has_method("get_informator"):
		emit_signal("level_complete")


func _on_LevelEndStop_body_entered(body):
	if body.has_method("get_informator"):
		emit_signal("player_stop")
