extends Area2D

class_name Stairs

export (String, "up", "down", "med") var type


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$med.hide()
	if type == "up":
		$up.show()
	elif type == "down":
		$down.show()
	else:
		$med.show() 
	pass # Replace with function body.


func get_class():
	return "Stairs"


func _on_Stairs_area_entered(area):
	if type == "up":
		$UpperLimit/CollisionShape2D.set_deferred("disabled", false)
	pass # Replace with function body.


func _on_Stairs_area_exited(area):
	if type == "up":
		$UpperLimit/CollisionShape2D.set_deferred("disabled", true)
	pass # Replace with function body.
