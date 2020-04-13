extends Node2D

var posRD
var posLU

signal level_complete


func _ready():
	posRD = $PositionRD.position
	posLU = $PositionLU.position
	
	$CanvasModulate.visible = true
	
	pass
