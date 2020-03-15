extends Node2D

var posRD
var posLU

signal level_complete


func _ready():
	posRD = $PositionRD.position
	posLU = $PositionLU.position
	
	$CanvasModulate.visible = true
	pass


func _on_LevelEnd_body_entered(body):
	if body.has_method("get_informator"):
		emit_signal("level_complete")
