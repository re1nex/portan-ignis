extends Light2D

const deltaScale = 0.0025
const energyDec = 0.025
const energyMin = 0.1

var reflected = false

var minScale
var energyMax
var switchingOff
var switchedOff

signal enabled
signal disabled
var priority = 1


func _ready():
	minScale = texture_scale - 0.01
	energyMax = 1.2
	switchingOff = not enabled
	switchedOff = enabled
	if switchedOff:
		finishDisabling()
	pass # Replace with function body.


func _process(delta):
	texture_scale = minScale + float(randf() / (minScale + deltaScale))
	if switchingOff and not switchedOff:
		# switching off is in process
		energy -= energyDec
		checkEnergy()
	if not switchingOff and switchedOff:
		# light needs to be switched on
		finishEnabling()


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


func checkEnergy():
	if energy <= energyMin:
		finishDisabling()
		switchedOff = true


func disable():
	switchingOff = true


func finishDisabling():
	$Area2D/CollisionShape2D.disabled = true
	enabled = false
	energy = 0
	switchedOff = true
	emit_signal("disabled")


func enable():
	switchingOff = false
	energy = energyMax


func finishEnabling():
	switchedOff = false
	$Area2D/CollisionShape2D.disabled = false
	enabled = true
	energy = energyMax
	emit_signal("enabled")
