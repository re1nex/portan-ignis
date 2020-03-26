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
var priority = 1

var reflected = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	minScale = texture_scale - 0.01
	energyMax = 1.2
	switchingOff = not enabled
	switchedOff = enabled
	if switchedOff:
		finish_disabling()
	pass # Replace with function body.


func _process(delta):
	texture_scale = minScale + float(randf() / (minScale + deltaScale))
	if switchingOff and not switchedOff:
		# switching off is in process
		energy -= energyDec
		checkEnergy()
	if not switchingOff and switchedOff:
		# light needs to be switched on
		finish_enabling()

func checkEnergy():
	if energy <= energyMin:
		finish_disabling()
		switchedOff = true


func disable():
	switchingOff = true


func finish_disabling():
	$Area2D/CollisionShape2D.disabled = true
	$Particles2D.emitting = false
	enabled = false
	energy = 0
	switchedOff = true
	emit_signal("disabled")


func enable():
	switchingOff = false
	energy = energyMax


func finish_enabling():
	switchedOff = false
	$Particles2D.emitting = true
	$Area2D/CollisionShape2D.disabled = false
	enabled = true
	energy = energyMax
	emit_signal("enabled")

func mirror():
	reflected *= -1
	pass

func rotate_ignis(degree):
	pass
