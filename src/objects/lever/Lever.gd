extends Area2D


signal lever_taken


func _ready():
	pass # Replace with function body.

func activate():
	emit_signal("lever_taken")
	queue_free()
