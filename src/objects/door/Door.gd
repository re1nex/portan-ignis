extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_IgnisRegularLevel_active():
	set_collision_layer_bit(0, false)
	$Sprite.hide()
	pass # Replace with function body.


func _on_IgnisRegularLevel_not_active():
	$Sprite.show()
	set_collision_layer_bit(0, true)
	pass # Replace with function body.
