extends MarginContainer
signal level0
signal level1



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	$HBoxContainer/VBoxContainer/mainView.hide()
	$HBoxContainer/VBoxContainer/StartView.show()

func _on_Settings_pressed():
	$HBoxContainer/VBoxContainer/mainView.hide()
	$HBoxContainer/Logo.hide()
	$HBoxContainer/VBoxContainer/Settings.show()

func _on_Help_pressed():
	$HBoxContainer/VBoxContainer/mainView.hide()
	$HBoxContainer/Logo.hide()
	$HBoxContainer/VBoxContainer/Help.show()


func _on_About_pressed():
	$HBoxContainer/VBoxContainer/mainView.hide()
	$HBoxContainer/Logo.hide()
	$HBoxContainer/VBoxContainer/About.show()


func _on_Exit_pressed():
	get_tree().quit()


func _on_backStart_pressed():
	$HBoxContainer/VBoxContainer/mainView.show()
	$HBoxContainer/VBoxContainer/StartView.hide()


func _on_backSettings_pressed():
	$HBoxContainer/VBoxContainer/Settings.hide()
	$HBoxContainer/VBoxContainer/mainView.show()
	$HBoxContainer/Logo.show()


func _on_CheckBox_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_BackAbout_pressed():
	$HBoxContainer/VBoxContainer/About.hide()
	$HBoxContainer/VBoxContainer/mainView.show()
	$HBoxContainer/Logo.show()


func _on_backHelp_pressed():
	$HBoxContainer/VBoxContainer/Help.hide()
	$HBoxContainer/VBoxContainer/mainView.show()
	$HBoxContainer/Logo.show()


func _on_level0_pressed():
	emit_signal("level0")


func _on_level1_pressed():
	emit_signal("level1")
