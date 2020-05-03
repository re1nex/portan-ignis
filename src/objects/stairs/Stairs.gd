extends Area2D

class_name Stairs

export (String, "up", "down", "med") var type


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$med.hide()
	if type == "up":
		$up.show()
		$UpperLimit/CollisionShape2D.disabled = false
	elif type == "down":
		$down.show()
	else:
		$med.show() 
	pass # Replace with function body.


func get_class():
	return "Stairs"
