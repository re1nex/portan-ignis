extends Area2D

signal active
signal not_active

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const activated_at_start = false
var body_informator = null
var activated = false


func _init():
	activated = false
# Called when the node enters the scene tree for the first time.


func _ready():
	if activated_at_start:
		activated = true
		$AudioLoop.play()
		$SpriteTorchOn.show()
		$SpriteTorchOff.hide()
		$Light2D.enable()
		emit_signal("active")
	else:
		activated = false
		$SpriteTorchOn.hide()
		$SpriteTorchOff.show()
		$Light2D.disable()
		emit_signal("not_active")
	pass # Replace with function body.
	
func activate_at_start():
	activated = true
	$Light2D.enable()
	$SpriteTorchOn.show()
	$SpriteTorchOff.hide()
	emit_signal("active")


func activate():
	if activated:
		$AudioLoop.stop()
		$AudioOff.play()
		$SpriteTorchOff.show()
		$SpriteTorchOn.hide()
		$Light2D.disable()
		activated = false
		emit_signal("not_active")
	else:
		if body_informator != null and body_informator.ignis_status == body_informator.Is_ignis.HAS_IGNIS:
			$AudioOff.stop()
			$AudioLoop.play()
			activated = true
			$Light2D.enable()
			$SpriteTorchOn.show()
			$SpriteTorchOff.hide()
			emit_signal("active")


func _on_IgnisRegularLevel_body_entered(body):
	if body.has_method("get_informator"):
		body_informator = body.get_informator()
	pass # Replace with function body.


func _on_IgnisRegularLevel_body_exited(body):
	if body.has_method("get_informator"):
		if body.get_informator() == body_informator:
			body_informator = null
	pass # Replace with function body.
