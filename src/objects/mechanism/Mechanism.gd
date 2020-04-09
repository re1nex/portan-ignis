extends Area2D

signal active
signal not_active

export var up_time = 7
export var down_time = 1
export var corner = 2 * PI
var time
var body_informator = null
var activated = false
var ready = false
var done = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	time = up_time
	pass # Replace with function body.

func activate():
	if not ready:
		if body_informator.has_instruments[GlobalVars.Instruments_type.LEVER] > 0:
			$Handle.show()
			body_informator.has_instruments[GlobalVars.Instruments_type.LEVER] -= 1

			ready = true
		
	elif not done:
		set_process(true)
		activated = true
		$Timer.set_wait_time(time)
		$Timer.start()
		emit_signal("active", up_time)
		


func disactivate():
	if activated and not done:
		emit_signal("not_active", down_time)
		time = $Timer.time_left
		$Timer.stop()
		activated = false



func _process(delta):
	if not activated:
		time += delta * up_time / down_time
		$Handle.rotate(-(delta * up_time / down_time) / up_time * corner)
		if time >= up_time:
			time = up_time
			set_process(false)
	else:
		$Handle.rotate(delta / up_time * corner)



func _on_Mechanism_body_entered(body):
	if body.has_method("get_informator"):
		body_informator = body.get_informator()
	pass # Replace with function body.


func _on_Mechanism_body_exited(body):
	if body.has_method("get_informator"):
		if body.get_informator() == body_informator:
			body_informator = null
	pass # Replace with function body.


func _on_Timer_timeout():
	done = true
	set_process(false)
	pass # Replace with function body.
