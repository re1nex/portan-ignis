extends Node2D



# Member variables
export var motion = Vector2(100, 0)
export var cycle = 4.0
var accum = 0.0

func _physics_process(delta):
	accum += delta * (1.0 / cycle) * PI * 2.0
	accum = fmod(accum, PI * 2.0)
	var d = sin(accum)
	var father = get_parent()
	var xf = father.transform
	xf[2] = motion * d
	var new_pos = motion * d
	father.transform = xf
#Vector2(64, 0), Vector2(0, 64), Vector2()

