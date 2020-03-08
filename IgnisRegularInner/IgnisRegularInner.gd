extends Light2D

const deltaScale = 0.0025

var minScale

signal enabled
signal disabled


# Called when the node enters the scene tree for the first time.
func _ready():
	minScale = texture_scale - 0.01
	pass # Replace with function body.


func _process(delta):
	texture_scale = minScale + float(randf() / (minScale + deltaScale))


func disable():
	$Area2D.monitorable = false
	$Particles2D.emitting = false
	enabled = false
	emit_signal("disabled")
	
func enable():
	$Particles2D.emitting = true
	$Area2D.monitorable = true
	enabled = true
	emit_signal("enabled")
