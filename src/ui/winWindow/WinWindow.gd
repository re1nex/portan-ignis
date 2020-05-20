extends CanvasLayer
var keyboard=false
var pos = -1
var coef = 1.5
var lastlvl =false
# Called when the node enters the scene tree for the first time.
func _ready():
	var en = $CenterContainer/VBoxContainer/NextLvl/ResLight.Ignis_layer.MENU
	
	$CenterContainer/VBoxContainer/NextLvl/ResLight.set_light_layer(en)
	$CenterContainer/VBoxContainer/MainMenu/MenuLight.set_light_layer(en)
	
	$CenterContainer/VBoxContainer/NextLvl/ResLight.disable()
	$CenterContainer/VBoxContainer/MainMenu/MenuLight.disable()

	$CenterContainer/VBoxContainer/NextLvl/ResLight.set_enemy_visible(false)
	$CenterContainer/VBoxContainer/MainMenu/MenuLight.set_enemy_visible(false)
	$CenterContainer.hide()
	if(SceneSwitcher.cur_scene==SceneSwitcher.Scenes.SCENE_STAGE_5):
		lastlvl=true
		$CenterContainer/VBoxContainer/NextLvl.hide()
	
	update_text()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$music.play()
	$CenterContainer.show()



func _input(event):
	if(!lastlvl):
		if($CenterContainer.is_visible_in_tree()):
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
			if event.is_action_pressed("ui_cancel"):
				_closeBeforeChange()
				pos-=1
			if event.is_action_pressed("ui_accept"):
				if(pos==0 && !$CenterContainer/VBoxContainer/NextLvl/ResLight.switchingOff):
					_on_NextLvl_pressed()
				if(pos==1 && !$CenterContainer/VBoxContainer/MainMenu/MenuLight.switchingOff):
					_on_MainMenu_pressed()
	else:
		if($CenterContainer.is_visible_in_tree()):
			if event is InputEventMouseMotion:
				if(keyboard) :
					_on_MainMenu_mouse_exited()
					keyboard=false
			if event.is_action_pressed("ui_down"): 
				_on_MainMenu_mouse_entered()
				keyboard=true
			if event.is_action_pressed("ui_up"):
				_on_MainMenu_mouse_entered()
				keyboard=true
			if event.is_action_pressed("ui_cancel"):
				_on_MainMenu_mouse_exited()
			if event.is_action_pressed("ui_accept"):
				if($CenterContainer/VBoxContainer/MainMenu/MenuLight.is_visible_in_tree()):
					_on_MainMenu_pressed()
	

func _closeBeforeChange():
	if(pos==0):
		_on_NextLvl_mouse_exited()
	if(pos==1):
		_on_MainMenu_mouse_exited()

func _closeBefore():
	if(pos==0):
		$CenterContainer/VBoxContainer/NextLvl/ResLight.hide()
		_on_NextLvl_mouse_exited()
	if(pos==1):
		$CenterContainer/VBoxContainer/MainMenu/MenuLight.hide()
		_on_MainMenu_mouse_exited()

func _ChangePos():
	if(pos<=0):
		pos=0 
		_on_NextLvl_mouse_entered()
	if(pos>=1):
		pos=1 
		_on_MainMenu_mouse_entered()

func _on_NextLvl_pressed():
	$AudioClick.play()
	pos=-1
	$CenterContainer/VBoxContainer/NextLvl/ResLight.disable()
	$CenterContainer/VBoxContainer/NextLvl/ResLight.hide()
	get_tree().paused=false
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_NEXT_SCENE)

func _on_NextLvl_mouse_entered():
	pos=0
	$CenterContainer/VBoxContainer/NextLvl/ResLight.enable()
	$CenterContainer/VBoxContainer/NextLvl/ResLight.show()


func _on_NextLvl_mouse_exited():
	$CenterContainer/VBoxContainer/NextLvl/ResLight.disable()


func _on_MainMenu_mouse_entered():
	pos=1
	$CenterContainer/VBoxContainer/MainMenu/MenuLight.show()
	$CenterContainer/VBoxContainer/MainMenu/MenuLight.enable()


func _on_MainMenu_mouse_exited():
	$CenterContainer/VBoxContainer/MainMenu/MenuLight.disable()


func _on_MainMenu_pressed():
	$AudioClick.play()
	pos=-1
	$CenterContainer/VBoxContainer/MainMenu/MenuLight.disable()
	$CenterContainer/VBoxContainer/MainMenu/MenuLight.hide()
	get_tree().paused=false
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_MAIN_MENU)


func update_text():
	var _key = GlobalVars.Storage_string_id.MENU
	$CenterContainer/VBoxContainer/NextLvl.text = textStorage.get_string(_key, "WindowWinNextLvl")
	$CenterContainer/VBoxContainer/MainMenu.text = textStorage.get_string(_key, "WindowWinMainExit")
	if(SceneSwitcher.cur_scene==SceneSwitcher.Scenes.SCENE_STAGE_5):
		$CenterContainer/VBoxContainer/Label.text = textStorage.get_string(_key, "WindowWinLabelEnd")
	else:
		$CenterContainer/VBoxContainer/Label.text = textStorage.get_string(_key, "WindowWinLabel")
