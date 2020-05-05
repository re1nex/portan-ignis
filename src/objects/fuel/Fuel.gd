extends Area2D

var amplitude = 5
var pos = 0
var step = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	if not $VisibilityEnabler2D.is_on_screen():
		set_process(false)


func _process(delta):
	pos += step * delta
	position.y += step * delta
	if abs(pos) >= amplitude:
		step *= -1 


func _on_Fuel_body_entered(body):
	if body.has_method("take_fuel"):
		if body.take_fuel():
			queue_free()
