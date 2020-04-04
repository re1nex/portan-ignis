extends Area2D

signal ignis_regular_taken

const radius_multiplier = 1.5

var lenSound=2.8
var type = Ignis.FIRST

enum Ignis{ 
	FIRST, 
	SECOND, 
	THIRD, 
	FOURTH,
}


func _ready():
	$Light2D.init_radius(radius_multiplier)
	$AudioLoop.play()


func activate():
	$AudioLoop.stop()
	emit_signal("ignis_regular_taken", type)
	queue_free()
