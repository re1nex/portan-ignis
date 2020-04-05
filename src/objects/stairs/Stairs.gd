extends Area2D

class_name Stairs

export (String, "up", "down", "med") var type


# Called when the node enters the scene tree for the first time.
func _ready():
	if type == "up":
		$up.show()
	elif type == "down":
		$down.show()
	else:
		$med.show() 
	pass # Replace with function body.


func get_class():
	return "Stairs"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
