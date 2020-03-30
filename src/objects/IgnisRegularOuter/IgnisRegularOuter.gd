extends Area2D
var lenSound=2.8
signal ignis_regular_taken
enum Ignis{ FIRST, SECOND, THIRD, FOURTH }

func _ready():
	$AudioLoop.play()

var type = Ignis.FIRST
func activate():
	$AudioLoop.stop()
	emit_signal("ignis_regular_taken", type)
	queue_free()
