extends MarginContainer
signal ChangePos

var keyboard = false
var pos = -1
var soundLen=0.22
var ScrollRange=56

var checkClick=false
var soundSet=false
var musicSet=false
var IgnisPlay=true
var testPlay=false
var secondPlay=false
var changeMute=false
var textActivate=false

var begin=true
var begin1=true
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#if(Settings.Sound["Volume"] != null):
	if Settings.Sound["Mute"]:
		$Settings/VBoxContainer/Label2/Mute/CheckBoxLight.show()
		$Settings/VBoxContainer/Label2/Mute.pressed=true
		$Settings/VBoxContainer/VolumeSettings/HSlider.value=0
		$Settings/VBoxContainer/MusicSettings/MusicHSlider.value=0
	else:
		$Settings/VBoxContainer/VolumeSettings/HSlider.value=Settings.Sound["Volume"]
		$Settings/VBoxContainer/MusicSettings/MusicHSlider.value=Settings.Sound["MusicVol"]
	if Settings.Graphics["Fullscreen"]:
		_full_Screen()
	if Settings.Graphics["Stretching"]:
		_stretch()
	$IgnisSound.play()
	begin=false
	begin1=false
	$Music2.stop()
	secondPlay=false
	$Music.play()
	testModeOff()
	
func testModeOff():
	$StartView/VBoxContainer/level0.disabled
	$StartView/VBoxContainer/level0.hide()

func _process(delta):
	if(!secondPlay):
		if(!$Music.is_playing()):
			secondPlay=true
			$Music2.play()
			return
	else:
		if(!$Music2.is_playing()):
			secondPlay=false
			$Music.play()


func checkIgnisSettings():
	return $Settings/VBoxContainer/Label/CheckBox/CheckBoxLight.is_visible_in_tree()||$Settings/VBoxContainer/stretchSettings/CheckBox/CheckBoxLight.is_visible_in_tree()||$Settings/VBoxContainer/Label2/Mute/CheckBoxLight.is_visible_in_tree()

func _input(event):
	if event is InputEventMouseMotion:
		if(keyboard) :
			_closeBeforeChange()
			textActivate=false
			keyboard=false
			pos=-1
	if event.is_action_pressed("ui_down"): 
		if(!textActivate):
			_closeBeforeChange()
			pos+=1
			keyboard=true
			_ChangePos()
		else:
			scrollDown()
	if event.is_action_pressed("ui_up"):
		if(!textActivate):
			_closeBeforeChange()
			pos-=1
			keyboard=true
			_ChangePos()
		else:
			scrollUp()
	if(event.is_action_pressed("ui_cancel")):
		_closeBeforeChange()
		_backToMain()

	if(soundSet):
		if event.is_action_pressed("ui_left"):
			var vol = Settings.Sound["Volume"] -4
			if(vol<0):vol=0
			$Settings/VBoxContainer/VolumeSettings/HSlider.value=vol
			$TestSound.play()
		if event.is_action_pressed("ui_right"):
			var vol = Settings.Sound["Volume"] +4
			if(vol>100):vol=100
			$Settings/VBoxContainer/VolumeSettings/HSlider.value=vol
			$TestSound.play()
	if(musicSet):
		if event.is_action_pressed("ui_left"):
			var vol = Settings.Sound["MusicVol"] -4
			if(vol<0):vol=0
			$Settings/VBoxContainer/MusicSettings/MusicHSlider.value=vol
			$TestSound2.play()
		if event.is_action_pressed("ui_right"):
			var vol = Settings.Sound["MusicVol"] +4
			if(vol>100):vol=100
			$Settings/VBoxContainer/MusicSettings/MusicHSlider.value=vol
			$TestSound2.play()
	if(event.is_action_pressed("ui_accept")):
		_pressButt()
		if(!checkClick&&!textActivate):
			_closeBeforeChange()
			pos=-1
		checkClick=false

func scrollDown():
	if $About.is_visible_in_tree():
		var num = $About/RichTextLabel.get_v_scroll().max_value
		var pos = $About/RichTextLabel.get_v_scroll().value
		if(pos+ScrollRange<num):
			$About/RichTextLabel.get_v_scroll().value=pos+ScrollRange
		else:
			$About/RichTextLabel.get_v_scroll().value=num
	if $Help.is_visible_in_tree():
		var num = $Help/VBoxContainer/ScrollContainer.get_v_scrollbar().max_value
		var pos = $Help/VBoxContainer/ScrollContainer.get_v_scrollbar().value
		if(pos+ScrollRange<num):
			$Help/VBoxContainer/ScrollContainer.get_v_scrollbar().value=pos+ScrollRange
		else:
			$Help/VBoxContainer/ScrollContainer.get_v_scrollbar().value=num

func scrollUp():
	if $About.is_visible_in_tree():
		var pos = $About/RichTextLabel.get_v_scroll().value
		if(pos-ScrollRange>0):
			$About/RichTextLabel.get_v_scroll().value=pos-ScrollRange
		else:
			$About/RichTextLabel.get_v_scroll().value=0
	if $Help.is_visible_in_tree():
		var pos = $Help/VBoxContainer/ScrollContainer.get_v_scrollbar().value
		if(pos-ScrollRange>0):
			$Help/VBoxContainer/ScrollContainer.get_v_scrollbar().value=pos-ScrollRange
		else:
			$Help/VBoxContainer/ScrollContainer.get_v_scrollbar().value=0

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
		if(pos==6 && $StartView/BackStart/LightBackStart.is_visible_in_tree()):
			_on_BackStart_pressed()
			return
		if(pos==0 && $StartView/VBoxContainer/level0/LightLevel0.is_visible_in_tree()):
			_on_level0_pressed()
			return
		if(pos==1 && $StartView/VBoxContainer/level1/LightLevel1.is_visible_in_tree()):
			_on_level1_pressed()
		if(pos==2 && $StartView/VBoxContainer/level2/LightLevel2.is_visible_in_tree()):
			_on_level2_pressed()
		if(pos==3 && $StartView/VBoxContainer/level3/LightLevel3.is_visible_in_tree()):
			_on_level3_pressed()
		if(pos==4 && $StartView/VBoxContainer/level4/LightLevel4.is_visible_in_tree()):
			_on_level4_pressed()
		if(pos==5 && $StartView/VBoxContainer/level5/LightLevel5.is_visible_in_tree()):
			_on_level5_pressed()
		return
	if($Settings.is_visible_in_tree() && $Settings.is_visible_in_tree()):
		if(pos>=5 && $Settings/BackSettings/LightBackStg.is_visible_in_tree()):
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
	if($About.is_visible_in_tree()):
		if(pos>=1 && $About/BackAbout/LightBackAbout.is_visible_in_tree()):
			_on_BackAbout_pressed()
			return
		if(pos==0 && $About/AboutText.is_visible_in_tree()):
			$ClickSound.play()
			textActivate=true
		return
	if($Help.is_visible_in_tree() ):
		if(pos>=1 && $Help/BackHelp/LightbackHelp.is_visible_in_tree()):
			_on_backHelp_pressed()
			return
		if(pos==0 && $Help/VBoxContainer/ScrollHelpLight.is_visible_in_tree()):
			$ClickSound.play()
			textActivate=true
		return

func _backToMain():
	if(!IgnisPlay):
		$IgnisSound.play()
		IgnisPlay=true
	if($StartView.is_visible_in_tree()):
		_on_BackStart_pressed()
		pos=-1
		return
	if($Settings.is_visible_in_tree()):
		_on_backSettings_pressed()
		pos=-1
		return
	if($About.is_visible_in_tree()):
		if(textActivate):
			textActivate=false
		else:
			pos=-1
			_on_BackAbout_pressed()
		return
	if($Help.is_visible_in_tree()):
		if(textActivate):
			textActivate=false
		else:
			pos=-1
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
		if(pos==6):
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
		if(pos==3):
			_on_level3_mouse_exited()
			return
		if(pos==4):
			_on_level4_mouse_exited()
			return
		if(pos==5):
			_on_level5_mouse_exited()
			return
		return
	if($Settings.is_visible_in_tree()):
		if(pos>=5):
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
		if(pos==4):
			_on_MusicSettings_mouse_exited()
		return
	if($About.is_visible_in_tree()):
		if(pos>=1):
			_on_BackAbout_mouse_exited()
		if(pos==0&&!textActivate):
			_on_RichTextLabel_mouse_exited()
		return
	if($Help.is_visible_in_tree()):
		if(pos>=1):
			_on_backHelp_mouse_exited()
		if(pos==0&&!textActivate):
			_on_ScrollContainer_mouse_exited()
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
	ConfigSave.save_to()
	get_tree().quit()




func _on_backSettings_pressed():
	pos=-1
	$ClickSound.play()
	$Settings.hide()
	$Settings/BackSettings/LightBackStg.hide()
	$Main/mainView.show()
	$Main/Logo.show()


func _full_Screen():
	if(Settings.Graphics["Fullscreen"]):
		$Settings/VBoxContainer/Label/CheckBox/CheckBoxLight.enable()
		$Settings/VBoxContainer/Label/CheckBox/CheckBoxLight.show()
		$Settings/VBoxContainer/Label/CheckBox.pressed=true
	else:
		$Settings/VBoxContainer/Label/CheckBox/CheckBoxLight.hide()
		$Settings/VBoxContainer/Label/CheckBox.pressed=false

func _on_CheckBox_pressed():
	$ClickSound.play()
	GraphicsController.set_fullscreen(!Settings.Graphics["Fullscreen"])
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
	$Music2.stop()
	$Music.stop()
	$ClickSound.play()
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_STAGE_0)

func _on_level1_pressed():
	pos=0
	$Music2.stop()
	$Music.stop()
	$ClickSound.play()
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_STAGE_1)

func _on_level2_pressed():
	pos=0
	$Music2.stop()
	$Music.stop()
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_STAGE_2)
	
func _on_level3_pressed():
	pos=0
	$Music2.stop()
	$Music.stop()
	$ClickSound.play()
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_STAGE_3)
	
func _on_level4_pressed():
	pos=0
	$Music2.stop()
	$Music.stop()
	$ClickSound.play()
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_STAGE_4)

func _on_level5_pressed():
	pos=0
	$Music2.stop()
	$Music.stop()
	$ClickSound.play()
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_STAGE_5)


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

func _on_level3_mouse_entered():
	pos=3
	$IgnisSound.play()
	IgnisPlay=true
	$StartView/VBoxContainer/level3/LightLevel3.show()
	$StartView/VBoxContainer/level3/LightLevel3.enable()


func _on_level3_mouse_exited():
	$IgnisSound.stop()
	IgnisPlay=false
	$StartView/VBoxContainer/level3/LightLevel3.hide()
	
func _on_level4_mouse_entered():
	pos=4
	$IgnisSound.play()
	IgnisPlay=true
	$StartView/VBoxContainer/level4/LightLevel4.show()
	$StartView/VBoxContainer/level4/LightLevel4.enable()


func _on_level4_mouse_exited():
	$IgnisSound.stop()
	IgnisPlay=false
	$StartView/VBoxContainer/level4/LightLevel4.hide()
	
func _on_level5_mouse_entered():
	pos=5
	$IgnisSound.play()
	IgnisPlay=true
	$StartView/VBoxContainer/level5/LightLevel5.show()
	$StartView/VBoxContainer/level5/LightLevel5.enable()


func _on_level5_mouse_exited():
	$IgnisSound.stop()
	IgnisPlay=false
	$StartView/VBoxContainer/level5/LightLevel5.hide()

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
	pos=6
	$StartView/BackStart/LightBackStart.show()
	$StartView/BackStart/LightBackStart.enable()


func _on_BackStart_mouse_exited():
	$IgnisSound.stop()
	IgnisPlay=false
	$StartView/BackStart/LightBackStart.hide()


func _on_backSettings_mouse_entered():
	pos=5
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
	pos=1
	IgnisPlay=true
	$IgnisSound.play()
	$About/BackAbout/LightBackAbout.show()
	$About/BackAbout/LightBackAbout.enable()


func _on_BackAbout_mouse_exited():
	$IgnisSound.stop()
	IgnisPlay=false
	$About/BackAbout/LightBackAbout.hide()


func _on_backHelp_mouse_entered():
	pos=1
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
		if(pos>=6):
			_on_BackStart_mouse_entered()
			return
		if(pos==0):
			_on_level0_mouse_entered()
			return
		if(pos==1):
			_on_level1_mouse_entered()
		if(pos==2):
			_on_level2_mouse_entered()
		if(pos==3):
			_on_level3_mouse_entered()
		if(pos==4):
			_on_level4_mouse_entered()
		if(pos==5):
			_on_level5_mouse_entered()
		return
	if($Settings.is_visible_in_tree()):
		if(pos>=5):
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
		if(pos==4):
			_on_MusicSettings_mouse_entered()
		return
	if($About.is_visible_in_tree()):
		if(pos>=1):
			_on_BackAbout_mouse_entered()
		if(pos==0):
			_on_RichTextLabel_mouse_entered()
		return
	if($Help.is_visible_in_tree()):
		if(pos>=1):
			_on_backHelp_mouse_entered()
		if(pos==0):
			_on_ScrollContainer_mouse_entered()
		return


func _stretch():
	if Settings.Graphics["Stretching"]:
		$Settings/VBoxContainer/stretchSettings/CheckBox/CheckBoxLight.enable()
		$Settings/VBoxContainer/stretchSettings/CheckBox/CheckBoxLight.show()
	else:
		$Settings/VBoxContainer/stretchSettings/CheckBox/CheckBoxLight.hide()


func _on_CheckBox_stretch_pressed():
	$ClickSound.play()
	GraphicsController.set_strecthing(!Settings.Graphics["Stretching"])
	_stretch()
	pass


func _on_HSlider_value_changed(value):
	if(!begin):
		$TestSound.stop()
	if value==0:
		$Settings/VBoxContainer/Label2/Mute/CheckBoxLight.show()
		$Settings/VBoxContainer/Label2/Mute.pressed=true
	else:
		$Settings/VBoxContainer/Label2/Mute/CheckBoxLight.hide()
		$Settings/VBoxContainer/Label2/Mute.pressed=false
	AudioController.changeVol(value)
	if(begin):
		begin=false



func _on_Mute_pressed():
	$ClickSound.play()
	changeMute=true
	if Settings.Sound["Mute"]:
		$Settings/VBoxContainer/VolumeSettings/HSlider.value=Settings.Sound["Volume"]
		$Settings/VBoxContainer/Label2/Mute/CheckBoxLight.hide()
		$Settings/VBoxContainer/Label2/Mute.pressed=false
		AudioController.turnVol(true)
		$Settings/VBoxContainer/MusicSettings/MusicHSlider.value=Settings.Sound["MusicVol"]
	else:
		$Settings/VBoxContainer/Label2/Mute.pressed=true
		$Settings/VBoxContainer/Label2/Mute/CheckBoxLight.show()
		$Settings/VBoxContainer/VolumeSettings/HSlider.value=0
		$Settings/VBoxContainer/MusicSettings/MusicHSlider.value=0
		AudioController.turnVol(false)
	changeMute=false


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


func _on_MusicSettings_mouse_entered():
	if(!IgnisPlay):
		IgnisPlay=true
		$IgnisSound.play()
	pos=4
	musicSet=true
	$Settings/VBoxContainer/MusicSettings/LightMusic.enable()
	$Settings/VBoxContainer/MusicSettings/LightMusic.show()


func _on_MusicSettings_mouse_exited():
	if(!checkIgnisSettings()):
		$IgnisSound.stop()
		IgnisPlay=false
	$TestSound2.stop()
	musicSet=false
	$Settings/VBoxContainer/MusicSettings/LightMusic.hide()


func _on_MusicHSlider_value_changed(value):
	if(!begin1):
		$TestSound2.stop()
	else:
		begin1=false
		return
	if !Settings.Sound["Mute"]:
		AudioController.changeMusicVol(value)


func _on_MusicHSlider_mouse_entered():
	_on_MusicSettings_mouse_entered()


func _on_MusicHSlider_mouse_exited():
	_on_MusicSettings_mouse_exited()


func _on_MusicHSlider_gui_input(event):
	if (event is InputEventMouseButton) && !event.pressed && (event.button_index == BUTTON_LEFT):
		$TestSound2.play()


func _on_RichTextLabel_mouse_entered():
	pos=0 
	$IgnisSound.play()
	$About/AboutText.enable()
	$About/AboutText.show()


func _on_RichTextLabel_mouse_exited():
	textActivate=false
	$About/AboutText.hide()
	$IgnisSound.stop()


func _on_ScrollContainer_mouse_entered():
	pos=0 
	$IgnisSound.play()
	$Help/VBoxContainer/ScrollHelpLight.enable()
	$Help/VBoxContainer/ScrollHelpLight.show()


func _on_ScrollContainer_mouse_exited():
	textActivate=false
	$Help/VBoxContainer/ScrollHelpLight.hide()
	$IgnisSound.stop()
