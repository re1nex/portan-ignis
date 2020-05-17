extends Node2D
export (String) var text
signal activate
signal disactivate
var activated=false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect.visible=false
	$TextureRect/VBoxContainer/RichTextLabel.text=text


func upd_text():
	$TextureRect/VBoxContainer/RichTextLabel.text=text


func _input(event):
	if(activated):
		if(event.is_action_pressed("ui_accept")):
			_on_TextureButton_pressed()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func activate():
	$TextureRect/Light2D.enabled=true
	pause_mode = PAUSE_MODE_PROCESS
	get_tree().paused = true
	emit_signal("activate")
	$TextureRect.visible=true
	activated=true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func disactivate():
	$TextureRect/Light2D.enabled=false
	get_tree().paused = false
	pause_mode = PAUSE_MODE_INHERIT
	emit_signal("disactivate")
	$TextureRect.visible=false
	activated=false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_TextureButton_pressed():
	disactivate()
