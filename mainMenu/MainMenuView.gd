extends MarginContainer

func _ready():
	if OS.window_fullscreen:
		$HBoxContainer/VBoxContainer/Settings/HBoxContainer/TextureRect/CheckBox.pressed = true


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
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_STAGE_TEST)


func _on_level1_pressed():
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_STAGE_1)
