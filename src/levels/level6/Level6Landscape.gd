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
