extends Area2D

signal ignis_regular_taken


func activate():
	emit_signal("ignis_regular_taken")
	queue_free()
