extends Node2D

var posRD
var posLU
signal hint_activate
signal hint_disactivate

func _ready():
	posRD = $PositionRD.position
	posLU = $PositionLU.position
	
	$CanvasModulate.visible = true
	
	pass


func _on_Hint_activate():
	emit_signal("hint_activate")


func _on_Hint_disactivate():
	emit_signal("hint_disactivate")
