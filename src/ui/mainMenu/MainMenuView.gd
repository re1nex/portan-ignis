extends MarginContainer
signal ChangePos

var keyboard = false
var fullScreen = false
var pos = -1

func _ready():
	if OS.window_fullscreen:
		$HBoxContainer/VBoxContainer/Settings/HBoxContainer/TextureRect/CheckBox.pressed = true


func _input(event):
	if event is InputEventMouseMotion:
		if(keyboard) :
			_closeBeforeChange()
			keyboard=false
			pos=0
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
		_backToMain()
		pos=-1
	if(event.is_action_pressed("ui_accept")):
		_pressButt()
		pos=-1



func _pressButt():
	if($HBoxContainer/VBoxContainer/mainView.is_visible_in_tree()):
		if(pos==4):
			_on_Exit_pressed()
			return
		if(pos==0):
			_on_Start_pressed()
			return
		if(pos==1):
			_on_Settings_pressed()
			return
		if(pos==2):
			_on_Help_pressed()
			return
		if(pos==3):
			_on_About_pressed()
		return
	if($HBoxContainer/VBoxContainer/StartView.is_visible_in_tree()):
		if(pos==2):
			_on_BackStart_pressed()
			return
		if(pos==0):
			_on_level0_pressed()
			return
		if(pos==1):
			_on_level1_pressed()
		return
	if($HBoxContainer/VBoxContainer/Settings.is_visible_in_tree()):
		_on_backSettings_pressed()
		return
	if($HBoxContainer/VBoxContainer/About.is_visible_in_tree()):
		_on_BackAbout_pressed()
		return
	if($HBoxContainer/VBoxContainer/Help.is_visible_in_tree()):
		_on_backHelp_pressed()
		return

func _backToMain():
	if($HBoxContainer/VBoxContainer/mainView.is_visible_in_tree()):
		_closeBeforeChange()
		return
	if($HBoxContainer/VBoxContainer/StartView.is_visible_in_tree()):
		_on_BackStart_pressed()
		return
	if($HBoxContainer/VBoxContainer/Settings.is_visible_in_tree()):
		_on_backSettings_pressed()
		return
	if($HBoxContainer/VBoxContainer/About.is_visible_in_tree()):
		_on_BackAbout_pressed()
		return
	if($HBoxContainer/VBoxContainer/Help.is_visible_in_tree()):
		_on_backHelp_pressed()
		return

func _closeBeforeChange():
	if($HBoxContainer/VBoxContainer/mainView.is_visible_in_tree()):
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
	if($HBoxContainer/VBoxContainer/StartView.is_visible_in_tree()):
		if(pos==2):
			_on_BackStart_mouse_exited()
			return
		if(pos==0):
			_on_level0_mouse_exited()
			return
		if(pos==1):
			_on_level1_mouse_exited()
			return
		return
	if($HBoxContainer/VBoxContainer/Settings.is_visible_in_tree()):
		_on_backSettings_mouse_exited()
		return
	if($HBoxContainer/VBoxContainer/About.is_visible_in_tree()):
		_on_BackAbout_mouse_exited()
		return
	if($HBoxContainer/VBoxContainer/Help.is_visible_in_tree()):
		_on_backHelp_mouse_exited()
		return

func _on_Start_pressed():
	pos=-1
	$HBoxContainer/VBoxContainer/mainView.hide()
	$HBoxContainer/VBoxContainer/StartView.show()
	$HBoxContainer/VBoxContainer/mainView/Sprite/Start/LightStart.disable()
	$HBoxContainer/VBoxContainer/mainView/Sprite/Start/LightStart.hide()

func _on_Settings_pressed():
	pos=-1
	$HBoxContainer/VBoxContainer/mainView.hide()
	$HBoxContainer/Logo.hide()
	$HBoxContainer/VBoxContainer/Settings.show()
	$HBoxContainer/VBoxContainer/mainView/Sprite/Settings/LightSettings.disable()
	$HBoxContainer/VBoxContainer/mainView/Sprite/Settings/LightSettings.hide()

func _on_Help_pressed():
	pos=-1
	$HBoxContainer/VBoxContainer/mainView.hide()
	$HBoxContainer/VBoxContainer/Help.show()
	$HBoxContainer/VBoxContainer/mainView/Sprite/Help/LightHelp.disable()
	$HBoxContainer/VBoxContainer/mainView/Sprite/Help/LightHelp.hide()


func _on_About_pressed():
	pos=-1
	$HBoxContainer/VBoxContainer/mainView.hide()
	$HBoxContainer/Logo.hide()
	$HBoxContainer/VBoxContainer/About.show()
	$HBoxContainer/VBoxContainer/mainView/Sprite/About/LightAbout.disable()
	$HBoxContainer/VBoxContainer/mainView/Sprite/About/LightAbout.hide()


func _on_Exit_pressed():
	get_tree().quit()





func _on_backSettings_pressed():
	pos=-1
	$HBoxContainer/VBoxContainer/Settings.hide()
	$HBoxContainer/VBoxContainer/Settings/Sprite/backSettings/LightBackStg.disable()
	$HBoxContainer/VBoxContainer/Settings/Sprite/backSettings/LightBackStg.hide()
	$HBoxContainer/VBoxContainer/mainView.show()
	$HBoxContainer/Logo.show()


func _full_Screen():
	if(fullScreen):
		$HBoxContainer/VBoxContainer/Settings/Sprite/Label/CheckBox/CheckBoxLight.enable()
		$HBoxContainer/VBoxContainer/Settings/Sprite/Label/CheckBox/CheckBoxLight.show()
	else:
		$HBoxContainer/VBoxContainer/Settings/Sprite/Label/CheckBox/CheckBoxLight.disable()

func _on_CheckBox_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
	fullScreen=!fullScreen
	_full_Screen()



func _on_BackAbout_pressed():
	pos=-1
	$HBoxContainer/VBoxContainer/About.hide()
	$HBoxContainer/VBoxContainer/About/Sprite/BackAbout/LightBackAbout.disable()
	$HBoxContainer/VBoxContainer/About/Sprite/BackAbout/LightBackAbout.hide()
	$HBoxContainer/VBoxContainer/mainView.show()
	$HBoxContainer/Logo.show()



func _on_backHelp_pressed():
	pos=-1
	$HBoxContainer/VBoxContainer/Help/Sprite/backHelp/LightbackHelp.disable()
	$HBoxContainer/VBoxContainer/Help/Sprite/backHelp/LightbackHelp.hide()
	$HBoxContainer/VBoxContainer/Help.hide()
	$HBoxContainer/VBoxContainer/mainView.show()



func _on_level0_pressed():
	pos=0
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_STAGE_0)
	$HBoxContainer/VBoxContainer/StartView/Sprite/level0/LightLevel0.disable()
	$HBoxContainer/VBoxContainer/StartView/Sprite/level0/LightLevel0.hide()


func _on_level1_pressed():
	pos=0
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_STAGE_1)
	$HBoxContainer/VBoxContainer/StartView/Sprite/level1/LightLevel1.disable()
	$HBoxContainer/VBoxContainer/StartView/Sprite/level1/LightLevel1.hide()





func _on_Start_mouse_exited():
	$HBoxContainer/VBoxContainer/mainView/Sprite/Start/LightStart.disable()



func _on_Start_mouse_entered():
	pos=0
	$HBoxContainer/VBoxContainer/mainView/Sprite/Start/LightStart.show()
	$HBoxContainer/VBoxContainer/mainView/Sprite/Start/LightStart.enable()


func _on_Settings_mouse_entered():
	pos=1
	$HBoxContainer/VBoxContainer/mainView/Sprite/Settings/LightSettings.show()
	$HBoxContainer/VBoxContainer/mainView/Sprite/Settings/LightSettings.enable()


func _on_Settings_mouse_exited():
	$HBoxContainer/VBoxContainer/mainView/Sprite/Settings/LightSettings.disable()


func _on_Help_mouse_entered():
	pos=2
	$HBoxContainer/VBoxContainer/mainView/Sprite/Help/LightHelp.show()
	$HBoxContainer/VBoxContainer/mainView/Sprite/Help/LightHelp.enable()


func _on_Help_mouse_exited():
	$HBoxContainer/VBoxContainer/mainView/Sprite/Help/LightHelp.disable()


func _on_About_mouse_entered():
	pos=3
	$HBoxContainer/VBoxContainer/mainView/Sprite/About/LightAbout.show()
	$HBoxContainer/VBoxContainer/mainView/Sprite/About/LightAbout.enable()


func _on_About_mouse_exited():
	$HBoxContainer/VBoxContainer/mainView/Sprite/About/LightAbout.disable()


func _on_Exit_mouse_entered():
	pos=4
	$HBoxContainer/VBoxContainer/mainView/Sprite/Exit/LightExit.show()
	$HBoxContainer/VBoxContainer/mainView/Sprite/Exit/LightExit.enable()


func _on_Exit_mouse_exited():
	$HBoxContainer/VBoxContainer/mainView/Sprite/Exit/LightExit.disable()


func _on_level0_mouse_entered():
	pos=0
	$HBoxContainer/VBoxContainer/StartView/Sprite/level0/LightLevel0.show()
	$HBoxContainer/VBoxContainer/StartView/Sprite/level0/LightLevel0.enable()


func _on_level0_mouse_exited():
	$HBoxContainer/VBoxContainer/StartView/Sprite/level0/LightLevel0.disable()


func _on_level1_mouse_entered():
	pos=1
	$HBoxContainer/VBoxContainer/StartView/Sprite/level1/LightLevel1.show()
	$HBoxContainer/VBoxContainer/StartView/Sprite/level1/LightLevel1.enable()


func _on_level1_mouse_exited():
	$HBoxContainer/VBoxContainer/StartView/Sprite/level1/LightLevel1.disable()


func _on_BackStart_pressed():
	pos=0
	$HBoxContainer/VBoxContainer/mainView.show()
	$HBoxContainer/VBoxContainer/StartView.hide()
	$HBoxContainer/VBoxContainer/StartView/Sprite/BackStart/LightBackStart.disable()
	$HBoxContainer/VBoxContainer/StartView/Sprite/BackStart/LightBackStart.hide()


func _on_BackStart_mouse_entered():
	pos=2
	$HBoxContainer/VBoxContainer/StartView/Sprite/BackStart/LightBackStart.show()
	$HBoxContainer/VBoxContainer/StartView/Sprite/BackStart/LightBackStart.enable()


func _on_BackStart_mouse_exited():
	$HBoxContainer/VBoxContainer/StartView/Sprite/BackStart/LightBackStart.disable()


func _on_backSettings_mouse_entered():
	pos=0
	$HBoxContainer/VBoxContainer/Settings/Sprite/backSettings/LightBackStg.show()
	$HBoxContainer/VBoxContainer/Settings/Sprite/backSettings/LightBackStg.enable()


func _on_backSettings_mouse_exited():
	$HBoxContainer/VBoxContainer/Settings/Sprite/backSettings/LightBackStg.disable()


func _on_BackAbout_mouse_entered():
	pos=0
	$HBoxContainer/VBoxContainer/About/Sprite/BackAbout/LightBackAbout.show()
	$HBoxContainer/VBoxContainer/About/Sprite/BackAbout/LightBackAbout.enable()


func _on_BackAbout_mouse_exited():
	$HBoxContainer/VBoxContainer/About/Sprite/BackAbout/LightBackAbout.disable()


func _on_backHelp_mouse_entered():
	pos=0
	$HBoxContainer/VBoxContainer/Help/Sprite/backHelp/LightbackHelp.show()
	$HBoxContainer/VBoxContainer/Help/Sprite/backHelp/LightbackHelp.enable()


func _on_backHelp_mouse_exited():
	$HBoxContainer/VBoxContainer/Help/Sprite/backHelp/LightbackHelp.disable()


func _ChangePos():
	if(pos<0):pos=0
	if($HBoxContainer/VBoxContainer/mainView.is_visible_in_tree()):
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
	if($HBoxContainer/VBoxContainer/StartView.is_visible_in_tree()):
		if(pos>=2):
			_on_BackStart_mouse_entered()
			return
		if(pos==0):
			_on_level0_mouse_entered()
			return
		if(pos==1):
			_on_level1_mouse_entered()
		return
	if($HBoxContainer/VBoxContainer/Settings.is_visible_in_tree()):
		pos=0 
		_on_backSettings_mouse_entered()
		return
	if($HBoxContainer/VBoxContainer/About.is_visible_in_tree()):
		pos=0 
		_on_BackAbout_mouse_entered()
		return
	if($HBoxContainer/VBoxContainer/Help.is_visible_in_tree()):
		pos=0
		_on_backHelp_mouse_entered()
		return
