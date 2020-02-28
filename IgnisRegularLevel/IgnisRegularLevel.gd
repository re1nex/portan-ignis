extends Area2D


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
		$SpriteTorchOn.show()
		$SpriteTorchOff.hide()
		$Light2D.enabled = true
	else:
		activated = false
		$SpriteTorchOn.hide()
		$SpriteTorchOff.show()
		$Light2D.enabled = false
	pass # Replace with function body.


func activate():
	if activated:
		$SpriteTorchOff.show()
		$SpriteTorchOn.hide()
		$Light2D.enabled = false
		activated = false
	else:
		if body_informator != null and body_informator.is_ignis:
			activated = true
			$Light2D.enabled = true
			$SpriteTorchOn.show()
			$SpriteTorchOff.hide()


func _on_IgnisRegularLevel_body_entered(body):
	if body.has_method("get_informator"):
		body_informator = body.get_informator()
	pass # Replace with function body.


func _on_IgnisRegularLevel_body_exited(body):
	if body.has_method("get_informator"):
		if body.get_informator() == body_informator:
			body_informator = null
	pass # Replace with function body.
