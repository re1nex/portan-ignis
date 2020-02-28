extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var body_informator = null
var activated = false


func _init():
	activated = false
# Called when the node enters the scene tree for the first time.


func _ready():
	activated = false
	$SpriteTorchOn.hide()
	$SpriteTorchOff.show()
	$Light2D.enabled = false	
	pass # Replace with function body.


func activate():
	if body_informator != null and body_informator.is_ignis:
		activated = !activated
		$Light2D.enabled = !$Light2D.enabled
		if activated:
			$SpriteTorchOff.hide()
			$SpriteTorchOn.show()	
		else:
			$SpriteTorchOn.hide()
			$SpriteTorchOff.show()	


func _on_body_exited(body):
	if body.has_method("get_informator"):
		if body.get_informator == body_informator:
			body_informator = null
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_IgnisRegularLevel_body_entered(body):
	if body.has_method("get_informator"):
		body_informator = body.get_informator()
	pass # Replace with function body.


func _on_IgnisRegularLevel_body_exited(body):
	if body.has_method("get_informator"):
		if body.get_informator() == body_informator:
			body_informator = null
	pass # Replace with function body.
