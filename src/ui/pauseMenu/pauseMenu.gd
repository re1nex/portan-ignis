extends CanvasLayer
var keyboard = false
var game_paused = false
export (bool) var hide_at_start = true
var pos = -1
var begin=true
var volSet=false
var IgnisPlay=false

func _ready():
	var en = $CenterContainer/Pause/Continue/ContLight.Ignis_layer.MENU
	$CenterContainer/Pause/Continue/ContLight.set_light_layer(en)
	$CenterContainer/Pause/Settings/SetLight.set_light_layer(en)
	$CenterContainer/Pause/MainMenu/MenuLight.set_light_layer(en)
	$CenterContainer/Settings/backSettings/backLight.set_light_layer(en)
	$CenterContainer/Settings/Label/CheckBox/CheckLight.set_light_layer(en)
	$CenterContainer/Pause/Restart/ResLight.set_light_layer(en)
	$CenterContainer/Settings/Label2/VolLight.set_light_layer(en)
	$CenterContainer/Settings/Label/LightFsc.set_light_layer(en)
	
	$CenterContainer/Pause/Continue/ContLight.hide()
	$CenterContainer/Pause/Settings/SetLight.hide()
	$CenterContainer/Pause/MainMenu/MenuLight.hide()
	$CenterContainer/Settings/backSettings/backLight.hide()
	$CenterContainer/Settings/Label/CheckBox/CheckLight.hide()
	$CenterContainer/Pause/Restart/ResLight.hide()
	$CenterContainer/Settings/Label2/VolLight.hide()
	$CenterContainer/Settings/Label/LightFsc.hide()
	
	$CenterContainer/Pause/Restart/ResLight.set_enemy_visible(false)
	$CenterContainer/Pause/Continue/ContLight.set_enemy_visible(false)
	$CenterContainer/Pause/Settings/SetLight.set_enemy_visible(false)
	$CenterContainer/Pause/MainMenu/MenuLight.set_enemy_visible(false)
	$CenterContainer/Settings/backSettings/backLight.set_enemy_visible(false)
	$CenterContainer/Settings/Label/CheckBox/CheckLight.set_enemy_visible(false)
	$CenterContainer/Settings/Label2/VolLight.set_enemy_visible(false)
	$CenterContainer/Settings/Label/LightFsc.set_enemy_visible(false)
	
	$CenterContainer/Settings/Label2/HSlider.value= Settings.Sound["Volume"]
	
	if hide_at_start:
		$CenterContainer.hide()
	if Settings.Graphics["Fullscreen"]:
		_full_screen()
	begin=false

func _input(event):
	if event is InputEventMouseMotion:
		if(keyboard) :
			_closeBeforeChange()
			keyboard=false
			pos=-1
	if event.is_action_pressed("ui_cancel"):
		if($CenterContainer/Pause.is_visible_in_tree()||!game_paused):
			_close_esc()
			game_paused = !game_paused
			process_pause()
		if($CenterContainer/Settings.is_visible_in_tree()):
			_closeBeforeChange()
			_on_backSettings_pressed()
		pos=-1
	if(game_paused):
		if event.is_action_pressed("ui_down"):
			_closeBeforeChange()
			pos+=1
			keyboard=true
			_changePos()
		if event.is_action_pressed("ui_up"):
			_closeBeforeChange()
			pos-=1
			keyboard=true
			_changePos()
		if event.is_action_pressed("ui_accept"):
			_pressButt()
			_closeBeforeChange()
			pos=-1
		if(volSet):
			if event.is_action_pressed("ui_left"):
				var vol = Settings.Sound["Volume"] -4
				if(vol<0):vol=0
				$CenterContainer/Settings/Label2/HSlider.value=vol
				$TestSound.play()
			if event.is_action_pressed("ui_right"):
				var vol = Settings.Sound["Volume"] +4
				if(vol>100):vol=100
				$CenterContainer/Settings/Label2/HSlider.value=vol
				$TestSound.play()




func _pressButt():
	if($CenterContainer/Pause.is_visible_in_tree()):
		if(pos==0 && $CenterContainer/Pause/Continue/ContLight.is_visible_in_tree()):
			_on_Continue_pressed()
			return
		if(pos==1 && $CenterContainer/Pause/Restart/ResLight.is_visible_in_tree()):
			_on_Restart_pressed()
			return
		if(pos==2 && $CenterContainer/Pause/Settings/SetLight.is_visible_in_tree()):
			_on_Settings_pressed()
			return
		if (pos==3 &&$CenterContainer/Pause/MainMenu/MenuLight.is_visible_in_tree()):
			_on_MainMenu_pressed()
			return
	if($CenterContainer/Settings.is_visible_in_tree()):
		if(pos==1 && $CenterContainer/Settings/Label/LightFsc.is_visible_in_tree()):
			_on_CheckBox_pressed()
			return
		if(pos==2 && $CenterContainer/Settings/backSettings/backLight.is_visible_in_tree()):
			_on_backSettings_pressed()
		return


func _close_esc():
	if(pos==0):
		_on_Continue_mouse_exited()
		return
	if(pos==1):
		_on_Restart_mouse_exited()
		return
	if (pos==2):
		_on_Settings_mouse_exited()
		return
	if (pos==3):
		_on_MainMenu_mouse_exited()
		return

func _changePos():
	if(pos<0):pos=0
	if($CenterContainer/Pause.is_visible_in_tree()):
		if(pos==0):
			_on_Continue_mouse_entered()
			return
		if(pos==1):
			_on_Restart_mouse_entered()
			return
		if (pos==2):
			_on_Settings_mouse_entered()
			return
		if(pos>=3):
			_on_MainMenu_mouse_entered()
			return
	if($CenterContainer/Settings.is_visible_in_tree()):
		if(pos==0):
			_on_Label2_mouse_entered()
			return
		if(pos==1):
			_on_Label_mouse_entered()
			return
		if(pos==2):
			_on_backSettings_mouse_entered()
		return

func _closeBeforeChange():
	if($CenterContainer/Pause.is_visible_in_tree()):
		_close_esc()
		return
	if($CenterContainer/Settings.is_visible_in_tree()):
		if(pos==0):
			_on_Label2_mouse_exited()
			return
		if(pos==1):
			_on_Label_mouse_exited()
			return
		if(pos==2):
			_on_backSettings_mouse_exited()
		return



func process_pause():
	if game_paused:
		pause_mode = PAUSE_MODE_PROCESS
		get_tree().paused = true
		$CenterContainer.show()
	else:
		get_tree().paused = false
		reset_menu();
		$CenterContainer.hide()
		pause_mode = PAUSE_MODE_INHERIT

func reset_menu():
	$CenterContainer/Settings.hide()
	$CenterContainer/Pause.show()


func _on_backSettings_pressed():
	$AudioClick.play()
	pos=-1
	$CenterContainer/Settings/backSettings/backLight.hide()
	$CenterContainer/Settings.hide()
	$CenterContainer/Pause.show()
	$IgnisSound.stop()

func _full_screen():
	if Settings.Graphics["Fullscreen"]:
		$CenterContainer/Settings/Label/CheckBox/CheckLight.enable()
		$CenterContainer/Settings/Label/CheckBox/CheckLight.show()
	else:
		$CenterContainer/Settings/Label/CheckBox/CheckLight.hide()


func _on_CheckBox_pressed():
	$AudioClick.play()
	GraphicsController.set_fullscreen(!Settings.Graphics["Fullscreen"])
	_full_screen()



func _on_Continue_pressed():
	$IgnisSound.stop()
	$AudioClick.play()
	$CenterContainer/Pause/Continue/ContLight.hide()
	pos=-1
	game_paused = false
	process_pause()


func _on_Settings_pressed():
	$AudioClick.play()
	pos=-1
	$CenterContainer/Pause/Settings/SetLight.hide()
	$CenterContainer/Pause.hide()
	$CenterContainer/Settings.show()
	if($CenterContainer/Settings/Label/CheckBox/CheckLight.is_visible_in_tree()):
		$IgnisSound.play()
	else:$IgnisSound.stop()



func _on_MainMenu_pressed():
	MusicController.playMusic(false)
	$IgnisSound.stop()
	$AudioClick.play()
	pos=-1
	$CenterContainer/Pause/MainMenu/MenuLight.hide()
	game_paused = false
	process_pause()
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_MAIN_MENU)


func _on_Continue_mouse_entered():
	$IgnisSound.play()
	pos=0
	$CenterContainer/Pause/Continue/ContLight.show()
	$CenterContainer/Pause/Continue/ContLight.enable()


func _on_Continue_mouse_exited():
	$IgnisSound.stop()
	$CenterContainer/Pause/Continue/ContLight.hide()


func _on_Settings_mouse_entered():
	$IgnisSound.play()
	pos=2
	$CenterContainer/Pause/Settings/SetLight.show()
	$CenterContainer/Pause/Settings/SetLight.enable()


func _on_MainMenu_mouse_entered():
	$IgnisSound.play()
	pos=3
	$CenterContainer/Pause/MainMenu/MenuLight.show()
	$CenterContainer/Pause/MainMenu/MenuLight.enable()


func _on_MainMenu_mouse_exited():
	$IgnisSound.stop()
	$CenterContainer/Pause/MainMenu/MenuLight.hide()


func _on_Settings_mouse_exited():
	$IgnisSound.stop()
	$CenterContainer/Pause/Settings/SetLight.hide()


func _on_backSettings_mouse_entered():
	if(!$CenterContainer/Settings/Label/CheckBox/CheckLight.is_visible_in_tree()):
		$IgnisSound.play()
	pos=2
	$CenterContainer/Settings/backSettings/backLight.enable()
	$CenterContainer/Settings/backSettings/backLight.show()


func _on_backSettings_mouse_exited():
	if(!$CenterContainer/Settings/Label/CheckBox/CheckLight.is_visible_in_tree()):
		$IgnisSound.stop()
	$CenterContainer/Settings/backSettings/backLight.hide()


func _on_Restart_pressed():
	MusicController.playMusic(false)
	$IgnisSound.stop()
	$AudioClick.play()
	$CenterContainer/Pause/Restart/ResLight.hide()
	pos=-1
	game_paused = false
	process_pause()
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_RESTART)


func _on_Restart_mouse_entered():
	$IgnisSound.play()
	$CenterContainer/Pause/Restart/ResLight.enable()
	$CenterContainer/Pause/Restart/ResLight.show()
	pos=1


func _on_Restart_mouse_exited():
	$IgnisSound.stop()
	$CenterContainer/Pause/Restart/ResLight.hide()


func _on_HSlider_value_changed(value):
	if(begin):
		begin=false
		return
	$TestSound.stop()
	AudioController.changeVol(value)


func _on_HSlider_mouse_exited():
	_on_Label2_mouse_exited()


func _on_Label2_mouse_exited():
	if(!$CenterContainer/Settings/Label/CheckBox/CheckLight.is_visible_in_tree()):
		$IgnisSound.stop()
	volSet=false
	$CenterContainer/Settings/Label2/VolLight.hide()
	$TestSound.stop()


func _on_Label2_mouse_entered():
	if(!$CenterContainer/Settings/Label/CheckBox/CheckLight.is_visible_in_tree()):
		$IgnisSound.play()
	volSet=true
	pos=0 
	$CenterContainer/Settings/Label2/VolLight.enable()
	$CenterContainer/Settings/Label2/VolLight.show()


func _on_Label_mouse_entered():
	if(!$CenterContainer/Settings/Label/CheckBox/CheckLight.is_visible_in_tree()):
		$IgnisSound.play()
	pos=1 
	$CenterContainer/Settings/Label/LightFsc.enable()
	$CenterContainer/Settings/Label/LightFsc.show()


func _on_Label_mouse_exited():
	if(!$CenterContainer/Settings/Label/CheckBox/CheckLight.is_visible_in_tree()):
		$IgnisSound.stop()
	$CenterContainer/Settings/Label/LightFsc.hide()


func _on_HSlider_mouse_entered():
	_on_Label2_mouse_entered()


func _on_CheckBox_mouse_entered():
	_on_Label_mouse_entered()


func _on_CheckBox_mouse_exited():
	_on_Label_mouse_exited()


func _on_HSlider_gui_input(event):
	if (event is InputEventMouseButton) && !event.pressed && (event.button_index == BUTTON_LEFT):
		$TestSound.play()
