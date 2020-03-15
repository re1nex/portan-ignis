extends Node2D

var posRD
var posLU

# Called when the node enters the scene tree for the first time.
func _ready():
	posRD = $PositionRD.position
	posLU = $PositionLU.position
	
	$CanvasModulate.visible = false
	pass # Replace with function body.
