extends Light2D

const deltaScale = 0.0025
const redDeviation = 0.0005

var minScale
var minRed
var minGreen
var minBlue

signal enabled
signal disabled


# Called when the node enters the scene tree for the first time.
func _ready():
	minScale = texture_scale - 0.01
	minRed = color.r - redDeviation / 2
	pass # Replace with function body.


func _process(delta):
	texture_scale = minScale + float(randf() / (minScale + deltaScale))
	color.r = minRed + float(randf() / (minRed + redDeviation))


func disable():
	$Area2D.monitorable = false
	$Particles2D.hide()
	enabled = false
	emit_signal("disabled")
	
func enable():
	$Particles2D.show()
	$Area2D.monitorable = true
	enabled = true
	emit_signal("enabled")
