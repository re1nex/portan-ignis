extends CanvasLayer
var keyboard = false
var game_paused = false
export (bool) var hide_at_start = true
var pos = -1

func _ready():
	var en = $CenterContainer/Pause/Continue/ContLight.Ignis_layer.MENU
	$CenterContainer/Pause/Continue/ContLight.set_light_layer(en)
	$CenterContainer/Pause/Settings/SetLight.set_light_layer(en)
	$CenterContainer/Pause/MainMenu/MenuLight.set_light_layer(en)
	$CenterContainer/Settings/backSettings/backLight.set_light_layer(en)
	$CenterContainer/Settings/Label/CheckBox/CheckLight.set_light_layer(en)
	
	$CenterContainer/Pause/Continue/ContLight.disable()
	$CenterContainer/Pause/Settings/SetLight.disable()
	$CenterContainer/Pause/MainMenu/MenuLight.disable()
	$CenterContainer/Settings/backSettings/backLight.disable()
	$CenterContainer/Settings/Label/CheckBox/CheckLight.disable()
	
	$CenterContainer/Pause/Continue/ContLight.set_enemy_visible(false)
	$CenterContainer/Pause/Settings/SetLight.set_enemy_visible(false)
	$CenterContainer/Pause/MainMenu/MenuLight.set_enemy_visible(false)
	$CenterContainer/Settings/backSettings/backLight.set_enemy_visible(false)
	$CenterContainer/Settings/Label/CheckBox/CheckLight.set_enemy_visible(false)
	
	if hide_at_start:
		$CenterContainer.hide()
	if OS.window_fullscreen:
		$CenterContainer/Settings/Label/CheckBox.pressed = true
		_full_screen()

func _input(event):
	if event is InputEventMouseMotion:
		if(keyboard) :
			_closeBeforeChange()
			keyboard=false
			pos=-1

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if($CenterContainer/Pause.is_visible_in_tree()||!game_paused):
			_close_esc()
			game_paused = !game_paused
			process_pause()
		if($CenterContainer/Settings.is_visible_in_tree()):
			_closeBeforeChange()
			_on_backSettings_pressed()
		pos=-1
	if(game_paused):
		if Input.is_action_just_pressed("ui_down"):
			_closeBeforeChange()
			pos+=1
			keyboard=true
			_changePos()
		if Input.is_action_just_pressed("ui_up"):
			_closeBeforeChange()
			pos-=1
			keyboard=true
			_changePos()
		if Input.is_action_just_pressed("ui_accept"):
			_pressButt()
			_closeBeforeChange()
			pos=-1


func _pressButt():
	if($CenterContainer/Pause.is_visible_in_tree()):
		if(pos==0 && !$CenterContainer/Pause/Continue/ContLight.switchingOff):
			_on_Continue_pressed()
			return
		if(pos==1 && !$CenterContainer/Pause/Settings/SetLight.switchingOff):
			_on_Settings_pressed()
			return
		if (pos==2 &&!$CenterContainer/Pause/MainMenu/MenuLight.switchingOff):
			_on_MainMenu_pressed()
			return
	if($CenterContainer/Settings.is_visible_in_tree() && !$CenterContainer/Settings/backSettings/backLight.switchingOff):
		_on_backSettings_pressed()
		return


func _close_esc():
	if(pos==0):
		_on_Continue_mouse_exited()
		$CenterContainer/Pause/Continue/ContLight.hide()
		return
	if(pos==1):
		_on_Settings_mouse_exited()
		$CenterContainer/Pause/Settings/SetLight.hide()
		return
	if (pos==2):
		_on_MainMenu_mouse_exited()
		$CenterContainer/Pause/MainMenu/MenuLight.hide()
		return

func _changePos():
	if(pos<0):pos=0
	if($CenterContainer/Pause.is_visible_in_tree()):
		if(pos==0):
			_on_Continue_mouse_entered()
			return
		if(pos==1):
			_on_Settings_mouse_entered()
			return
		if (pos>=2):
			_on_MainMenu_mouse_entered()
			return
	if($CenterContainer/Settings.is_visible_in_tree()):
		_on_backSettings_mouse_entered()
		return

func _closeBeforeChange():
	if($CenterContainer/Pause.is_visible_in_tree()):
		if(pos==0):
			_on_Continue_mouse_exited()
			return
		if(pos==1):
			_on_Settings_mouse_exited()
			return
		if (pos==2):
			_on_MainMenu_mouse_exited()
			return
	if($CenterContainer/Settings.is_visible_in_tree()):
		_on_backSettings_mouse_exited()
		return



func process_pause():
	if game_paused:
		get_tree().paused = true
		$CenterContainer.show()
	else:
		get_tree().paused = false
		reset_menu();
		$CenterContainer.hide()

func reset_menu():
	$CenterContainer/Settings.hide()
	$CenterContainer/Pause.show()


func _on_backSettings_pressed():
	$AudioClick.play()
	pos=-1
	$CenterContainer/Settings/backSettings/backLight.disable()
	$CenterContainer/Settings/backSettings/backLight.hide()
	$CenterContainer/Settings.hide()
	$CenterContainer/Pause.show()

func _full_screen():
	if OS.window_fullscreen:
		$CenterContainer/Settings/Label/CheckBox/CheckLight.enable()
		$CenterContainer/Settings/Label/CheckBox/CheckLight.show()
	else:
		$CenterContainer/Settings/Label/CheckBox/CheckLight.disable()


func _on_CheckBox_pressed():
	$AudioClick.play()
	OS.window_fullscreen = !OS.window_fullscreen
	_full_screen()

func _disablePause():
	$CenterContainer/Pause/Continue/ContLight.hide()
	$CenterContainer/Pause/Continue/ContLight.disable()
	$CenterContainer/Pause/Settings/SetLight.hide()
	$CenterContainer/Pause/Settings/SetLight.disable()
	$CenterContainer/Pause/MainMenu/MenuLight.hide()
	$CenterContainer/Pause/MainMenu/MenuLight.disable()

func _on_Continue_pressed():
	$AudioClick.play()
	_disablePause()
	pos=-1
	game_paused = false
	process_pause()


func _on_Settings_pressed():
	$AudioClick.play()
	pos=-1
	$CenterContainer/Pause.hide()
	$CenterContainer/Settings.show()
	_disablePause()



func _on_MainMenu_pressed():
	$AudioClick.play()
	pos=-1
	_disablePause()
	game_paused = false
	process_pause()
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_MAIN_MENU)


func _on_Continue_mouse_entered():
	pos=0
	$CenterContainer/Pause/Continue/ContLight.show()
	$CenterContainer/Pause/Continue/ContLight.enable()


func _on_Continue_mouse_exited():
	$CenterContainer/Pause/Continue/ContLight.disable()


func _on_Settings_mouse_entered():
	pos=1
	$CenterContainer/Pause/Settings/SetLight.show()
	$CenterContainer/Pause/Settings/SetLight.enable()


func _on_MainMenu_mouse_entered():
	pos=2
	$CenterContainer/Pause/MainMenu/MenuLight.show()
	$CenterContainer/Pause/MainMenu/MenuLight.enable()


func _on_MainMenu_mouse_exited():
	$CenterContainer/Pause/MainMenu/MenuLight.disable()


func _on_Settings_mouse_exited():
	$CenterContainer/Pause/Settings/SetLight.disable()


func _on_backSettings_mouse_entered():
	$CenterContainer/Settings/backSettings/backLight.enable()
	$CenterContainer/Settings/backSettings/backLight.show()


func _on_backSettings_mouse_exited():
	$CenterContainer/Settings/backSettings/backLight.disable()
