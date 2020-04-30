extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var STEP = 0.1
var step 
# Called when the node enters the scene tree for the first time.
func _ready():
	step = STEP
	set_process(false)
	pass # Replace with function body.

func _process(delta):
	var x = $Sprites.get_modulate()
	var alpha = x.a
	
	alpha += step
	if alpha >= 1:
		alpha = 1
		step = -STEP
	if alpha <= 0:
		alpha = 0
		step = STEP
		set_process(false)
	
	x.a = alpha
	$Sprites.set_modulate(x)


func init_player(player):
	# connect signals
	player.connect("got_hit", self, "_on_got_hit")

func _on_got_hit():
	set_process(true)
	step = STEP
