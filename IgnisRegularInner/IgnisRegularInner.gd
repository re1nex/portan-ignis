extends Light2D

const deltaScale = 0.0025
const energyDec = 0.025
const energyMin = 0.1

var minScale
var energyMax
var switchingOff
var switchedOff

signal enabled
signal disabled


# Called when the node enters the scene tree for the first time.
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

func checkEnergy():
	if energy <= energyMin:
		finishDisabling()
		switchedOff = true


func disable():
	switchingOff = true


func finishDisabling():
	$Area2D.monitorable = false
	$Particles2D.emitting = false
	enabled = false
	energy = 0
	switchedOff = true
	emit_signal("disabled")


func enable():
	switchingOff = false


func finishEnabling():
	switchedOff = false
	$Particles2D.emitting = true
	$Area2D.monitorable = true
	enabled = true
	energy = energyMax
	emit_signal("enabled")
