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


func _on_IgnisSectorOuter_body_entered(body):
	if body.has_method("_on_IgnisRegularOuter_ignis_regular_taken"):
		body._on_IgnisRegularOuter_ignis_regular_taken(GlobalVars.Ignis_type.SECTOR)
		queue_free()
	pass # Replace with function body.
