extends Area2D

signal ignis_regular_taken
enum Ignis{ FIRST, SECOND, THIRD, FOURTH }

var type = Ignis.FIRST
func activate():
	emit_signal("ignis_regular_taken", type)
	queue_free()
