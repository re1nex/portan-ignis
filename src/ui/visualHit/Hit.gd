extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var STEP = 0.1
var step 
# Called when the node enters the scene tree for the first time.
func _ready():
	step = STEP
	#set_process(false)
	pass # Replace with function body.

func _process(delta):
	var x = $Sprites.get_modulate()
	if x.a > 0.95:
		step = -STEP
	elif x.a < 0.05:
		step = STEP
	x.a += step
	$Sprites.set_modulate(x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
