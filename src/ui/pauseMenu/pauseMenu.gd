extends MarginContainer

var game_paused = false
export (bool) var hide_at_start = true


func _ready():
	if hide_at_start:
		hide()
	if OS.window_fullscreen:
		$CenterContainer/background/CenterContainer/Settings/Sprite/TextureRect/CheckBox.pressed = true


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		game_paused = !game_paused
		process_pause()


func process_pause():
	if game_paused:
		get_tree().paused = true
		show()
	else:
		get_tree().paused = false
		reset_menu();
		hide()

func reset_menu():
	$CenterContainer/background/CenterContainer/Settings.hide()
	$CenterContainer/background/CenterContainer/Pause.show()


func _on_backSettings_pressed():
	$CenterContainer/background/CenterContainer/Settings.hide()
	$CenterContainer/background/CenterContainer/Pause.show()


func _on_CheckBox_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_Continue_pressed():
	game_paused = false
	process_pause()


func _on_Settings_pressed():
	$CenterContainer/background/CenterContainer/Pause.hide()
	$CenterContainer/background/CenterContainer/Settings.show()


func _on_MainMenu_pressed():
	game_paused = false
	process_pause()
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_MAIN_MENU)
