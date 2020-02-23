extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


signal ignis_regular_taken


func _process(delta): # For testing only
	if Input.is_action_pressed("ui_left"):
		activate()


func activate():
	emit_signal("ignis_regular_taken")
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
