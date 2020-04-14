extends Area2D


signal lever_taken


var amplitude = 4
var pos = 0
var step = 20

func _ready():
	if not $VisibilityEnabler2D.is_on_screen():
		set_process(false)
	pass # Replace with function body.

func _process(delta):
	pos += step * delta
	position.y += step * delta
	if abs(pos) >= amplitude:
		step *= -1 
	pass


func activate():
	emit_signal("lever_taken")
	queue_free()
