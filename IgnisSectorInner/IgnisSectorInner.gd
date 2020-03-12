extends Light2D

var reflected = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func mirror():
	reflected = not reflected
	rotation = -rotation
	clamp_rotation()
	pass


func clamp_rotation():
	# rotation must be in [-PI; PI]
	if rotation <= -PI:
		rotation = -PI
	if rotation > PI:
		rotation = PI


func rotate_ignis(val):
	if reflected:
		val *= -1
	if rotation * (rotation + val) < 0:
		# val changes rotation sign
		rotation = 0 # border value
		pass
	rotation += val
	clamp_rotation()
	pass
