extends Light2D


signal enabled
signal disabled


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func disable():
	$Area2D.monitorable = false
	enabled = false
	emit_signal("disabled")
	
func enable():
	$Area2D.monitorable = true
	enabled = true
	emit_signal("enabled")
