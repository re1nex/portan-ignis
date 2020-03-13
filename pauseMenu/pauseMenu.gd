extends MarginContainer
signal Continue
signal ExitMenu

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_backSettings_pressed():
	$CenterContainer/background/CenterContainer/Settings.hide()
	$CenterContainer/background/CenterContainer/Pause.show()


func _on_CheckBox_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_Continue_pressed():
	emit_signal("Continue")


func _on_Settings_pressed():
	$CenterContainer/background/CenterContainer/Pause.hide()
	$CenterContainer/background/CenterContainer/Settings.show()


func _on_MainMenu_pressed():
	emit_signal("ExitMenu")
