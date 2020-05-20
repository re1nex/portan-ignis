extends Area2D

var amplitude = 5
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
	pass

func _on_grenadeLevel_body_entered(body):
	if body.has_method("take_grenade"):
		if body.take_grenade():
			queue_free()
	pass # Replace with function body.
