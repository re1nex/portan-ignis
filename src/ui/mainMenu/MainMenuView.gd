extends MarginContainer
signal ChangePos

var keyboard = false
var fullScreen = false
var pos = -1
var soundLen=0.22

func _ready():
	if OS.window_fullscreen:
		fullScreen=true
		_full_Screen()
	if SceneSwitcher.strech:
		_stretch()


func _input(event):
	if event is InputEventMouseMotion:
		if(keyboard) :
			_closeBeforeChange()
			keyboard=false
			pos=-1
	if event.is_action_pressed("ui_down"): 
		_closeBeforeChange()
		pos+=1
		keyboard=true
		_ChangePos()
	if event.is_action_pressed("ui_up"):
		_closeBeforeChange()
		pos-=1
		keyboard=true
		_ChangePos()
	if(event.is_action_pressed("ui_cancel")):
		_closeBeforeChange()
		_backToMain()
		pos=-1
	if(event.is_action_pressed("ui_accept")):
		_pressButt()
		_closeBeforeChange()
		pos=-1



func _pressButt():
	if($HBoxContainer/mainView.is_visible_in_tree()):
		if(pos==4 && !$HBoxContainer/mainView/Exit/LightExit.switchingOff):
			_on_Exit_pressed()
			return
		if(pos==0 && !$HBoxContainer/mainView/Start/LightStart.switchingOff):
			_on_Start_pressed()
			return
		if(pos==1 && !$HBoxContainer/mainView/Settings/LightSettings.switchingOff):
			_on_Settings_pressed()
			return
		if(pos==2 && !$HBoxContainer/mainView/Help/LightHelp.switchingOff):
			_on_Help_pressed()
			return
		if(pos==3 && !$HBoxContainer/mainView/About/LightAbout.switchingOff):
			_on_About_pressed()
		return
	if($StartView.is_visible_in_tree()):
		if(pos==3 && !$StartView/BackStart/LightBackStart.switchingOff):
			_on_BackStart_pressed()
			return
		if(pos==0 && !$StartView/VBoxContainer/level0/LightLevel0.switchingOff):
			_on_level0_pressed()
			return
		if(pos==1 && !$StartView/VBoxContainer/level1/LightLevel1.switchingOff):
			_on_level1_pressed()
		if(pos==2 && !$StartView/VBoxContainer/level2/LightLevel2.switchingOff):
			_on_level2_pressed()
		return
	if($Settings.is_visible_in_tree() && !$Settings/BackSettings/LightBackStg.switchingOff):
		_on_backSettings_pressed()
		return
	if($About.is_visible_in_tree() && !$About/BackAbout/LightBackAbout.switchingOff):
		_on_BackAbout_pressed()
		return
	if($Help.is_visible_in_tree() && !$Help/BackHelp/LightbackHelp.switchingOff):
		_on_backHelp_pressed()
		return

func _backToMain():
	if($HBoxContainer/mainView.is_visible_in_tree()):
		_closeBeforeChange()
		return
	if($StartView.is_visible_in_tree()):
		_on_BackStart_pressed()
		return
	if($Settings.is_visible_in_tree()):
		_on_backSettings_pressed()
		return
	if($About.is_visible_in_tree()):
		_on_BackAbout_pressed()
		return
	if($Help.is_visible_in_tree()):
		_on_backHelp_pressed()
		return

func _closeBeforeChange():
	if($HBoxContainer/mainView.is_visible_in_tree()):
		if(pos==4):
			_on_Exit_mouse_exited()
			return
		if(pos==0):
			_on_Start_mouse_exited()
			return
		if(pos==1):
			_on_Settings_mouse_exited()
			return
		if(pos==2):
			_on_Help_mouse_exited()
			return
		if(pos==3):
			_on_About_mouse_exited()
		return
	if($StartView.is_visible_in_tree()):
		if(pos==3):
			_on_BackStart_mouse_exited()
			return
		if(pos==0):
			_on_level0_mouse_exited()
			return
		if(pos==1):
			_on_level1_mouse_exited()
		if(pos==2):
			_on_level2_mouse_exited()
			return
		return
	if($Settings.is_visible_in_tree()):
		_on_backSettings_mouse_exited()
		return
	if($About.is_visible_in_tree()):
		_on_BackAbout_mouse_exited()
		return
	if($Help.is_visible_in_tree()):
		_on_backHelp_mouse_exited()
		return


func _disableMain():
	$HBoxContainer/mainView/Start/LightStart.disable()
	$HBoxContainer/mainView/Start/LightStart.hide()
	$HBoxContainer/mainView/Settings/LightSettings.disable()
	$HBoxContainer/mainView/Settings/LightSettings.hide()
	$HBoxContainer/mainView/Help/LightHelp.disable()
	$HBoxContainer/mainView/Help/LightHelp.hide()
	$HBoxContainer/mainView/About/LightAbout.disable()
	$HBoxContainer/mainView/About/LightAbout.hide()
	$HBoxContainer/mainView/Exit/LightExit.disable()
	$HBoxContainer/mainView/Exit/LightExit.hide()

func _disableStart():
	$StartView/VBoxContainer/level0/LightLevel0.disable()
	$StartView/VBoxContainer/level0/LightLevel0.hide()
	$StartView/VBoxContainer/level1/LightLevel1.disable()
	$StartView/VBoxContainer/level1/LightLevel1.hide()
	$StartView/VBoxContainer/level2/LightLevel2.disable()
	$StartView/VBoxContainer/level2/LightLevel2.hide()
	$StartView/BackStart/LightBackStart.disable()
	$StartView/BackStart/LightBackStart.hide()

func _on_Start_pressed():
	pos=-1
	$HBoxContainer/Logo.hide()
	$ClickSound.play()
	$HBoxContainer/mainView.hide()
	$StartView.show()
	_disableMain()

func _on_Settings_pressed():
	pos=-1
	$ClickSound.play()
	$HBoxContainer/mainView.hide()
	$HBoxContainer/Logo.hide()
	$Settings.show()
	_disableMain()

func _on_Help_pressed():
	pos=-1
	$ClickSound.play()
	$HBoxContainer/Logo.hide()
	$HBoxContainer/mainView.hide()
	$Help.show()
	_disableMain()


func _on_About_pressed():
	pos=-1
	$ClickSound.play()
	$HBoxContainer/mainView.hide()
	$HBoxContainer/Logo.hide()
	$About.show()
	_disableMain()


func _on_Exit_pressed():
	$ClickSound.play()
	while($ClickSound.get_playback_position()<soundLen):pos=-1
	get_tree().quit()




func _on_backSettings_pressed():
	pos=-1
	$ClickSound.play()
	$Settings.hide()
	$Settings/BackSettings/LightBackStg.disable()
	$Settings/BackSettings/LightBackStg.hide()
	$HBoxContainer/mainView.show()
	$HBoxContainer/Logo.show()


func _full_Screen():
	if(fullScreen):
		$Settings/VBoxContainer/Label/CheckBox/CheckBoxLight.enable()
		$Settings/VBoxContainer/Label/CheckBox/CheckBoxLight.show()
	else:
		$Settings/VBoxContainer/Label/CheckBox/CheckBoxLight.disable()

func _on_CheckBox_pressed():
	$ClickSound.play()
	OS.window_fullscreen = !OS.window_fullscreen
	fullScreen=!fullScreen
	_full_Screen()



func _on_BackAbout_pressed():
	pos=-1
	$ClickSound.play()
	$About.hide()
	$About/BackAbout/LightBackAbout.disable()
	$About/BackAbout/LightBackAbout.hide()
	$HBoxContainer/mainView.show()
	$HBoxContainer/Logo.show()



func _on_backHelp_pressed():
	pos=-1
	$ClickSound.play()
	$Help/BackHelp/LightbackHelp.disable()
	$Help/BackHelp/LightbackHelp.hide()
	$Help.hide()
	$HBoxContainer/mainView.show()
	$HBoxContainer/Logo.show()



func _on_level0_pressed():
	pos=0
	$ClickSound.play()
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_STAGE_0)
	_disableStart()

func _on_level1_pressed():
	pos=0
	$ClickSound.play()
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_STAGE_1)
	_disableStart()

func _on_level2_pressed():
	pos=0
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_STAGE_2)
	_disableStart()



func _on_Start_mouse_exited():
	$HBoxContainer/mainView/Start/LightStart.disable()



func _on_Start_mouse_entered():
	pos=0
	$HBoxContainer/mainView/Start/LightStart.show()
	$HBoxContainer/mainView/Start/LightStart.enable()


func _on_Settings_mouse_entered():
	pos=1
	$HBoxContainer/mainView/Settings/LightSettings.show()
	$HBoxContainer/mainView/Settings/LightSettings.enable()


func _on_Settings_mouse_exited():
	$HBoxContainer/mainView/Settings/LightSettings.disable()


func _on_Help_mouse_entered():
	pos=2
	$HBoxContainer/mainView/Help/LightHelp.show()
	$HBoxContainer/mainView/Help/LightHelp.enable()


func _on_Help_mouse_exited():
	$HBoxContainer/mainView/Help/LightHelp.disable()


func _on_About_mouse_entered():
	pos=3
	$HBoxContainer/mainView/About/LightAbout.show()
	$HBoxContainer/mainView/About/LightAbout.enable()


func _on_About_mouse_exited():
	$HBoxContainer/mainView/About/LightAbout.disable()


func _on_Exit_mouse_entered():
	pos=4
	$HBoxContainer/mainView/Exit/LightExit.show()
	$HBoxContainer/mainView/Exit/LightExit.enable()


func _on_Exit_mouse_exited():
	$HBoxContainer/mainView/Exit/LightExit.disable()


func _on_level0_mouse_entered():
	pos=0
	$StartView/VBoxContainer/level0/LightLevel0.show()
	$StartView/VBoxContainer/level0/LightLevel0.enable()


func _on_level0_mouse_exited():
	$StartView/VBoxContainer/level0/LightLevel0.disable()


func _on_level1_mouse_entered():
	pos=1
	$StartView/VBoxContainer/level1/LightLevel1.show()
	$StartView/VBoxContainer/level1/LightLevel1.enable()


func _on_level1_mouse_exited():
	$StartView/VBoxContainer/level1/LightLevel1.disable()

func _on_level2_mouse_entered():
	pos=2
	$StartView/VBoxContainer/level2/LightLevel2.show()
	$StartView/VBoxContainer/level2/LightLevel2.enable()


func _on_level2_mouse_exited():
	$StartView/VBoxContainer/level2/LightLevel2.disable()

func _on_BackStart_pressed():
	pos=0
	$ClickSound.play()
	$HBoxContainer/mainView.show()
	$StartView.hide()
	$HBoxContainer/Logo.show()
	_disableStart()
	


func _on_BackStart_mouse_entered():
	pos=3
	$StartView/BackStart/LightBackStart.show()
	$StartView/BackStart/LightBackStart.enable()


func _on_BackStart_mouse_exited():
	$StartView/BackStart/LightBackStart.disable()


func _on_backSettings_mouse_entered():
	pos=0
	$Settings/BackSettings/LightBackStg.show()
	$Settings/BackSettings/LightBackStg.enable()


func _on_backSettings_mouse_exited():
	$Settings/BackSettings/LightBackStg.disable()


func _on_BackAbout_mouse_entered():
	pos=0
	$About/BackAbout/LightBackAbout.show()
	$About/BackAbout/LightBackAbout.enable()


func _on_BackAbout_mouse_exited():
	$About/BackAbout/LightBackAbout.disable()


func _on_backHelp_mouse_entered():
	pos=0
	$Help/BackHelp/LightbackHelp.show()
	$Help/BackHelp/LightbackHelp.enable()


func _on_backHelp_mouse_exited():
	$Help/BackHelp/LightbackHelp.disable()


func _ChangePos():
	if(pos<0):pos=0
	if($HBoxContainer/mainView.is_visible_in_tree()):
		if(pos>=4):
			_on_Exit_mouse_entered()
			return
		if(pos==0):
			_on_Start_mouse_entered()
			return
		if(pos==1):
			_on_Settings_mouse_entered()
			return
		if(pos==2):
			_on_Help_mouse_entered()
			return
		if(pos==3):
			_on_About_mouse_entered()
		return
	if($StartView.is_visible_in_tree()):
		if(pos>=3):
			_on_BackStart_mouse_entered()
			return
		if(pos==0):
			_on_level0_mouse_entered()
			return
		if(pos==1):
			_on_level1_mouse_entered()
		if(pos==2):
			_on_level2_mouse_entered()
		return
	if($Settings.is_visible_in_tree()):
		pos=0 
		_on_backSettings_mouse_entered()
		return
	if($About.is_visible_in_tree()):
		pos=0 
		_on_BackAbout_mouse_entered()
		return
	if($Help.is_visible_in_tree()):
		pos=0
		_on_backHelp_mouse_entered()
		return


func _stretch():
	$Settings/VBoxContainer/stretchSettings/CheckBox.pressed = true
	$Settings/VBoxContainer/stretchSettings/CheckBox/CheckBoxLight.enable()
	$Settings/VBoxContainer/stretchSettings/CheckBox/CheckBoxLight.show()


func _on_CheckBox_stretch_pressed():
	$ClickSound.play()
	SceneSwitcher.strech = !SceneSwitcher.strech
	if SceneSwitcher.strech:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(1280, 720))
		$Settings/VBoxContainer/stretchSettings/CheckBox/CheckBoxLight.enable()
		$Settings/VBoxContainer/stretchSettings/CheckBox/CheckBoxLight.show()
	else:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, Vector2(1280, 720))
		$Settings/VBoxContainer/stretchSettings/CheckBox/CheckBoxLight.disable()
	pass
