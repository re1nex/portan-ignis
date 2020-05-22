extends RigidBody2D

var timer 
var got_hit = false
var parent

#parent.get_node("Light2D")
# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_node("Timer")
	parent = get_parent()
	parent.get_node("Light2D").reload(GlobalVars.Ignis_state.LIFE_2)
	pass # Replace with function body

func _on_Timer_timeout():
	get_parent().queue_free()

func _on_GrenadeBody_body_entered(body):
	if not got_hit:
		parent.get_node("Light2D").reload(GlobalVars.Ignis_state.LIFE_MAX)
		parent.get_node("Light2D").scale *= 2
		parent.get_node("Light2D").energy *= 2
		timer.start()
		$TimerRoll.start()
		#contacts_reported = 0
		got_hit = true
	pass # Replace with function body.


func _on_TimerRoll_timeout():
	if got_hit:
		mode = MODE_STATIC
	else:
		apply_torque_impulse(0.1)
	pass # Replace with function body.
