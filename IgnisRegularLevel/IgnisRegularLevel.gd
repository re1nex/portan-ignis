extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var activated = false

func _process(delta): # For testing only
	if Input.is_action_pressed("ui_right"):
		activate()


func _init():
	activated = false	
	$SpriteTorchOn.hide()
	$SpriteTorchOff.show()
	$Light2D.hide()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func activate():
	activated = !activated
	if activated:
		$SpriteTorchOff.hide()
		$SpriteTorchOn.show()
		$Light2D.show() # does it hide light from enemies, too?
	else:
		$SpriteTorchOn.hide()
		$SpriteTorchOff.show()		
		$Light2D.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
