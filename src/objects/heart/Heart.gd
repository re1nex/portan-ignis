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
	if body.has_method("get_informator"):
		var body_informator = body.get_informator()
		if body_informator != null and body_informator.health < 5:
			body_informator.health += 1
			queue_free()
	pass # Replace with function body.
