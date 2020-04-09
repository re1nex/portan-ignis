extends MarginContainer
signal ChangePos

var keyboard = false
var fullScreen = false
var pos = -1
var soundLen=0.22

var checkClick=false
var soundSet=false
var IgnisPlay=true
var testPlay=false

func _ready():
	if OS.window_fullscreen:
		fullScreen=true
		_full_Screen()
	if SceneSwitcher.strech:
		_stretch()
	$IgnisSound.play()


func checkIgnisSettings():
	return $Settings/VBoxContainer/Label/CheckBox/CheckBoxLight.is_visible_in_tree()||$Settings/VBoxContainer/stretchSettings/CheckBox/CheckBoxLight.is_visible_in_tree()||$Settings/VBoxContainer/Label2/Mute/CheckBoxLight.is_visible_in_tree()

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
	if(soundSet):
		if event.is_action_pressed("ui_left"):
			var vol = AudioController.sound-4
			if(vol<0):vol=0
			$Settings/VBoxContainer/VolumeSettings/HSlider.value=vol
			$TestSound.play()
		if event.is_action_pressed("ui_right"):
			var vol = AudioController.sound+4
			if(vol>100):vol=100
			$Settings/VBoxContainer/VolumeSettings/HSlider.value=vol
			$TestSound.play()
	if(event.is_action_pressed("ui_accept")):
		_pressButt()
		if(!checkClick):
			_closeBeforeChange()
			pos=-1
		checkClick=false



func _pressButt():
	if($Main/mainView.is_visible_in_tree()):
		if(pos==4 && $Main/mainView/Exit/LightExit.is_visible_in_tree()):
			_on_Exit_pressed()
			return
		if(pos==0 && $Main/mainView/Start/LightStart.is_visible_in_tree()):
			_on_Start_pressed()
			return
		if(pos==1 && $Main/mainView/Settings/LightSettings.is_visible_in_tree()):
			_on_Settings_pressed()
			return
		if(pos==2 && $Main/mainView/Help/LightHelp.is_visible_in_tree()):
			_on_Help_pressed()
			return
		if(pos==3 && $Main/mainView/About/LightAbout.is_visible_in_tree()):
			_on_About_pressed()
		return
	if($StartView.is_visible_in_tree()):
		if(pos==3 && $StartView/BackStart/LightBackStart.is_visible_in_tree()):
			_on_BackStart_pressed()
			return
		if(pos==0 && $StartView/VBoxContainer/level0/LightLevel0.is_visible_in_tree()):
			_on_level0_pressed()
			return
		if(pos==1 && $StartView/VBoxContainer/level1/LightLevel1.is_visible_in_tree()):
			_on_level1_pressed()
		if(pos==2 && $StartView/VBoxContainer/level2/LightLevel2.is_visible_in_tree()):
			_on_level2_pressed()
		return
	if($Settings.is_visible_in_tree() && $Settings.is_visible_in_tree()):
		if(pos>=4 && $Settings/BackSettings/LightBackStg.is_visible_in_tree()):
			_on_backSettings_pressed()
			return
		if(pos==0 && $Settings/VBoxContainer/Label/LightFsc.is_visible_in_tree()):
			_on_CheckBox_pressed()
			checkClick=true
			$Settings/VBoxContainer/Label/LightFsc.show()
			return
		if(pos==1 && $Settings/VBoxContainer/stretchSettings/LightStr.is_visible_in_tree()):
			_on_CheckBox_stretch_pressed()
			checkClick=true
			return
		if(pos==2 && $Settings/VBoxContainer/Label2/LightMut.is_visible_in_tree()):
			_on_Mute_pressed()
			checkClick=true
			return
		return
	if($About.is_visible_in_tree() && $About/BackAbout/LightBackAbout.is_visible_in_tree()):
		_on_BackAbout_pressed()
		return
	if($Help.is_visible_in_tree() && $Help/BackHelp/LightbackHelp.is_visible_in_tree()):
		_on_backHelp_pressed()
		return

func _backToMain():
	if(!IgnisPlay):
		$IgnisSound.play()
		IgnisPlay=true
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
	if($Main/mainView.is_visible_in_tree()):
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
		if(pos>=4):
			_on_backSettings_mouse_exited()
			return
		if(pos==0):
			_on_Label_mouse_exited()
			return
		if(pos==1):
			_on_stretchSettings_mouse_exited()
			return
		if(pos==2):
			_on_Label2_mouse_exited()
			return
		if(pos==3):
			_on_VolumeSettings_mouse_exited()
		return
	if($About.is_visible_in_tree()):
		_on_BackAbout_mouse_exited()
		return
	if($Help.is_visible_in_tree()):
		_on_backHelp_mouse_exited()
		return


func _on_Start_pressed():
	$IgnisSound.stop()
	IgnisPlay=false
	pos=-1
	$Main/mainView/Start/LightStart.hide()
	$Main/Logo.hide()
	$ClickSound.play()
	$Main/mainView.hide()
	$StartView.show()

func _on_Settings_pressed():
	pos=-1
	$Main/mainView/Settings/LightSettings.hide()
	$ClickSound.play()
	$Main/mainView.hide()
	$Main/Logo.hide()
	$Settings.show()
	if(checkIgnisSettings()):
		$IgnisSound.play()
		IgnisPlay=true
	else:
		$IgnisSound.stop()
		IgnisPlay=false

func _on_Help_pressed():
	$IgnisSound.stop()
	IgnisPlay=false
	pos=-1
	$Main/mainView/Help/LightHelp.hide()
	$ClickSound.play()
	$Main/Logo.hide()
	$Main/mainView.hide()
	$Help.show()


func _on_About_pressed():
	$IgnisSound.stop()
	IgnisPlay=false
	pos=-1
	$Main/mainView/About/LightAbout.hide()
	$ClickSound.play()
	$Main/mainView.hide()
	$Main/Logo.hide()
	$About.show()


func _on_Exit_pressed():
	$ClickSound.play()
	while($ClickSound.get_playback_position()<soundLen):pos=-1
	get_tree().quit()




func _on_backSettings_pressed():
	pos=-1
	$ClickSound.play()
	$Settings.hide()
	$Settings/BackSettings/LightBackStg.hide()
	$Main/mainView.show()
	$Main/Logo.show()


func _full_Screen():
	if(fullScreen):
		$Settings/VBoxContainer/Label/CheckBox/CheckBoxLight.enable()
		$Settings/VBoxContainer/Label/CheckBox/CheckBoxLight.show()
	else:
		$Settings/VBoxContainer/Label/CheckBox/CheckBoxLight.hide()

func _on_CheckBox_pressed():
	$ClickSound.play()
	OS.window_fullscreen = !OS.window_fullscreen
	fullScreen=!fullScreen
	_full_Screen()



func _on_BackAbout_pressed():
	pos=-1
	$ClickSound.play()
	$About.hide()
	$About/BackAbout/LightBackAbout.hide()
	$Main/mainView.show()
	$Main/Logo.show()



func _on_backHelp_pressed():
	pos=-1
	$ClickSound.play()
	$Help/BackHelp/LightbackHelp.hide()
	$Help.hide()
	$Main/mainView.show()
	$Main/Logo.show()



func _on_level0_pressed():
	pos=0
	$ClickSound.play()
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_STAGE_0)

func _on_level1_pressed():
	pos=0
	$ClickSound.play()
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_STAGE_1)

func _on_level2_pressed():
	pos=0
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_STAGE_2)



func _on_Start_mouse_exited():
	$Main/mainView/Start/LightStart.hide()



func _on_Start_mouse_entered():
	pos=0
	$Main/mainView/Start/LightStart.show()
	$Main/mainView/Start/LightStart.enable()


func _on_Settings_mouse_entered():
	pos=1
	$Main/mainView/Settings/LightSettings.show()
	$Main/mainView/Settings/LightSettings.enable()


func _on_Settings_mouse_exited():
	$Main/mainView/Settings/LightSettings.hide()


func _on_Help_mouse_entered():
	pos=2
	$Main/mainView/Help/LightHelp.show()
	$Main/mainView/Help/LightHelp.enable()


func _on_Help_mouse_exited():
	$Main/mainView/Help/LightHelp.hide()


func _on_About_mouse_entered():
	pos=3
	$Main/mainView/About/LightAbout.show()
	$Main/mainView/About/LightAbout.enable()


func _on_About_mouse_exited():
	$Main/mainView/About/LightAbout.hide()


func _on_Exit_mouse_entered():
	pos=4
	$Main/mainView/Exit/LightExit.show()
	$Main/mainView/Exit/LightExit.enable()


func _on_Exit_mouse_exited():
	$Main/mainView/Exit/LightExit.hide()


func _on_level0_mouse_entered():
	pos=0
	$IgnisSound.play()
	IgnisPlay=true
	$StartView/VBoxContainer/level0/LightLevel0.show()
	$StartView/VBoxContainer/level0/LightLevel0.enable()


func _on_level0_mouse_exited():
	$IgnisSound.stop()
	IgnisPlay=false
	$StartView/VBoxContainer/level0/LightLevel0.hide()


func _on_level1_mouse_entered():
	pos=1
	$IgnisSound.play()
	IgnisPlay=true
	$StartView/VBoxContainer/level1/LightLevel1.show()
	$StartView/VBoxContainer/level1/LightLevel1.enable()


func _on_level1_mouse_exited():
	$IgnisSound.stop()
	IgnisPlay=false
	$StartView/VBoxContainer/level1/LightLevel1.hide()

func _on_level2_mouse_entered():
	pos=2
	$IgnisSound.play()
	IgnisPlay=true
	$StartView/VBoxContainer/level2/LightLevel2.show()
	$StartView/VBoxContainer/level2/LightLevel2.enable()


func _on_level2_mouse_exited():
	$IgnisSound.stop()
	IgnisPlay=false
	$StartView/VBoxContainer/level2/LightLevel2.hide()

func _on_BackStart_pressed():
	pos=0
	$StartView/BackStart/LightBackStart.hide()
	$ClickSound.play()
	$Main/mainView.show()
	$StartView.hide()
	$Main/Logo.show()


func _on_BackStart_mouse_entered():
	$IgnisSound.play()
	IgnisPlay=true
	pos=3
	$StartView/BackStart/LightBackStart.show()
	$StartView/BackStart/LightBackStart.enable()


func _on_BackStart_mouse_exited():
	$IgnisSound.stop()
	IgnisPlay=false
	$StartView/BackStart/LightBackStart.hide()


func _on_backSettings_mouse_entered():
	pos=4
	if(!IgnisPlay):
		IgnisPlay=true
		$IgnisSound.play()
	$Settings/BackSettings/LightBackStg.show()
	$Settings/BackSettings/LightBackStg.enable()


func _on_backSettings_mouse_exited():
	if(!checkIgnisSettings()):
		$IgnisSound.stop()
		IgnisPlay=false
	$Settings/BackSettings/LightBackStg.hide()


func _on_BackAbout_mouse_entered():
	pos=0
	IgnisPlay=true
	$IgnisSound.play()
	$About/BackAbout/LightBackAbout.show()
	$About/BackAbout/LightBackAbout.enable()


func _on_BackAbout_mouse_exited():
	$IgnisSound.stop()
	IgnisPlay=false
	$About/BackAbout/LightBackAbout.hide()


func _on_backHelp_mouse_entered():
	pos=0
	IgnisPlay=true
	$IgnisSound.play()
	$Help/BackHelp/LightbackHelp.show()
	$Help/BackHelp/LightbackHelp.enable()


func _on_backHelp_mouse_exited():
	$IgnisSound.stop()
	IgnisPlay=false
	$Help/BackHelp/LightbackHelp.hide()


func _ChangePos():
	if(pos<0):pos=0
	if($Main/mainView.is_visible_in_tree()):
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
		if(pos>=4):
			_on_backSettings_mouse_entered()
			return
		if(pos==0):
			_on_Label_mouse_entered()
			return
		if(pos==1):
			_on_stretchSettings_mouse_entered()
		if(pos==2):
			_on_Label2_mouse_entered()
		if(pos==3):
			_on_VolumeSettings_mouse_entered()
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
		$Settings/VBoxContainer/stretchSettings/CheckBox/CheckBoxLight.hide()
	pass


func _on_HSlider_value_changed(value):
	$TestSound.stop()
	if value==0:
		$Settings/VBoxContainer/Label2/Mute/CheckBoxLight.show()
	else:
		$Settings/VBoxContainer/Label2/Mute/CheckBoxLight.hide()
	AudioController.changeVol(value)


func _on_Mute_pressed():
	$ClickSound.play()
	if AudioController.mute:
		$Settings/VBoxContainer/Label2/Mute/CheckBoxLight.hide()
		$Settings/VBoxContainer/VolumeSettings/HSlider.value=AudioController.sound
		AudioController.turnVol(true)
	else:
		$Settings/VBoxContainer/Label2/Mute/CheckBoxLight.show()
		$Settings/VBoxContainer/VolumeSettings/HSlider.value=0
		AudioController.turnVol(false)


func _on_Label_mouse_entered():
	if(!IgnisPlay):
		IgnisPlay=true
		$IgnisSound.play()
	pos=0
	$Settings/VBoxContainer/Label/LightFsc.enable()
	$Settings/VBoxContainer/Label/LightFsc.show()


func _on_Label_mouse_exited():
	if(!checkIgnisSettings()):
		$IgnisSound.stop()
		IgnisPlay=false
	$Settings/VBoxContainer/Label/LightFsc.hide()


func _on_stretchSettings_mouse_entered():
	if(!IgnisPlay):
		IgnisPlay=true
		$IgnisSound.play()
	pos=1
	$Settings/VBoxContainer/stretchSettings/LightStr.enable()
	$Settings/VBoxContainer/stretchSettings/LightStr.show()


func _on_stretchSettings_mouse_exited():
	if(!checkIgnisSettings()):
		$IgnisSound.stop()
		IgnisPlay=false
	$Settings/VBoxContainer/stretchSettings/LightStr.hide()


func _on_Label2_mouse_entered():
	if(!IgnisPlay):
		IgnisPlay=true
		$IgnisSound.play()
	pos=2
	$Settings/VBoxContainer/Label2/LightMut.enable()
	$Settings/VBoxContainer/Label2/LightMut.show()


func _on_Label2_mouse_exited():
	if(!checkIgnisSettings()):
		$IgnisSound.stop()
		IgnisPlay=false
	$Settings/VBoxContainer/Label2/LightMut.hide()


func _on_VolumeSettings_mouse_entered():
	if(!IgnisPlay):
		IgnisPlay=true
		$IgnisSound.play()
	pos=3
	soundSet=true
	$Settings/VBoxContainer/VolumeSettings/LightVol.enable()
	$Settings/VBoxContainer/VolumeSettings/LightVol.show()


func _on_VolumeSettings_mouse_exited():
	if(!checkIgnisSettings()):
		$IgnisSound.stop()
		IgnisPlay=false
	$TestSound.stop()
	soundSet=false
	$Settings/VBoxContainer/VolumeSettings/LightVol.hide()





func _on_CheckBox_mouse_entered():
	_on_Label_mouse_entered()


func _on_CheckBox_mouse_exited():
	_on_Label_mouse_exited()


func _on_CheckBoxStr_mouse_entered():
	_on_stretchSettings_mouse_entered()



func _on_CheckBoxStr_mouse_exited():
	_on_stretchSettings_mouse_exited()


func _on_Mute_mouse_entered():
	_on_Label2_mouse_entered()


func _on_HSlider_mouse_entered():
	_on_VolumeSettings_mouse_entered()


func _on_HSlider_mouse_exited():
	_on_VolumeSettings_mouse_exited()


func _on_Mute_mouse_exited():
	_on_Label2_mouse_exited()


func _on_HSlider_gui_input(event):
	if (event is InputEventMouseButton) && !event.pressed && (event.button_index == BUTTON_LEFT):
		$TestSound.play()
