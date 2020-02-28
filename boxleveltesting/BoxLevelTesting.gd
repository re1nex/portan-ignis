extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var posRD = $PositionRD.position
	var posLU = $PositionLU.position
	$Player/Camera.limit_left = posLU.x
	$Player/Camera.limit_top = posLU.y
	$Player/Camera.limit_right = posRD.x
	$Player/Camera.limit_bottom = posRD.y
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
