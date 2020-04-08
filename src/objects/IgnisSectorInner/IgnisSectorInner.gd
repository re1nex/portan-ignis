extends Light2D

const deltaScale = 0.001
const deltaScaleCircle = 0.1 # circle postfix means it's for circle light2D
const energyDec = 0.025
const energyMin = 0.1

var reflected = 1

var minScale
var minScaleCircle
var energyMax
var switchingOff
var switchedOff

signal enabled
signal disabled
var priority = 1


func _ready():
	minScale = texture_scale
	minScaleCircle = $Circle.texture_scale
	rotate(PI / 2)
	energyMax = 1.2
	switchingOff = not enabled
	switchedOff = enabled
	if switchedOff:
		finishDisabling()
	
	pass # Replace with function body.


func _process(delta):
	texture_scale = minScale + float(randf() * deltaScale/ (minScale))
	$Circle.texture_scale = minScaleCircle + float(randf() * deltaScaleCircle/ (minScaleCircle))
	if switchingOff and not switchedOff:
		# switching off is in process
		energy -= energyDec
		$Circle.energy -= energyDec
		checkEnergy()
	if not switchingOff and switchedOff:
		# light needs to be switched on
		finishEnabling()


func mirror():
	reflected = - reflected
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
	val *= reflected
	if reflected * (rotation + val) < 0:
		# val changes rotation sign
		rotation = 0 # border value
		return
	rotation += val
	clamp_rotation()
	pass


func checkEnergy():
	if energy <= energyMin:
		finishDisabling()
		switchedOff = true


func disable():
	switchingOff = true


func finishDisabling():
	$Area2D/CollisionShape2D.disabled = true
	$Area2D/Circle.disabled = true
	$Lens.hide()
	enabled = false
	$Circle.enabled = false
	$Circle.energy = 0
	energy = 0
	switchedOff = true
	set_process(false)
	emit_signal("disabled")


func enable():
	switchingOff = false
	energy = energyMax
	$Circle.energy = energyMax
	set_process(true)


func finishEnabling():
	switchedOff = false
	$Area2D/CollisionShape2D.disabled = false
	$Area2D/Circle.disabled = false
	$Lens.show()
	enabled = true
	$Circle.enabled = true
	energy = energyMax
	$Circle.energy = energyMax
	emit_signal("enabled")
