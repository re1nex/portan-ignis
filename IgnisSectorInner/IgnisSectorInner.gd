extends Light2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func mirror():
	texture_scale *= -1
	$Area2D.scale *= -1
	pass


func rotate_ignis(degree):
	rotate(deg2rad(degree))
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
