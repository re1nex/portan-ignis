extends Area2D

var amplitude = 5
var pos = 0
var step = 20


func _ready():
	pass # Replace with function body.


func _process(delta):
	pos += step * delta
	position.y += step * delta
	if abs(pos) >= amplitude:
		step *= -1 
	pass

func activate():
	
	pass

func _on_Heart_body_entered(body):
	if body.has_method("take_heart"):
		if body.take_heart():
			queue_free()
	pass # Replace with function body.
