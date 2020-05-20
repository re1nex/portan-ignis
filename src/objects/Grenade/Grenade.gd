extends RigidBody2D

var timer 
# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_node("Timer")
	$Light2D.reload(GlobalVars.Ignis_state.LIFE_1)
	pass # Replace with function body


func _on_Timer_timeout():
	queue_free()


func _on_Grenade_body_entered(body):
	#apply_impulse(Vector2(), Vector2.UP.rotated(PI/4) * 500)
	#var light = get_node("FlyingLight")
	#light.texture_scale *= 10
	#light.energy *= 3
	$Light2D.reload(GlobalVars.Ignis_state.LIFE_MAX)
	$Light2D.scale *= 2
	$Light2D.energy *= 2
	timer.start()
	contacts_reported = 0
	pass # Replace with function body.

