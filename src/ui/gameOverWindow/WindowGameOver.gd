extends CanvasLayer
var keyboard=false
var pos = -1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var en = $CenterContainer/VBoxContainer/Restart/ResLight.Ignis_layer.MENU
	
	$CenterContainer/VBoxContainer/Restart/ResLight.set_light_layer(en)
	$CenterContainer/VBoxContainer/MainMenu/MenuLight.set_light_layer(en)
	
	$CenterContainer/VBoxContainer/Restart/ResLight.disable()
	$CenterContainer/VBoxContainer/MainMenu/MenuLight.disable()

	$CenterContainer/VBoxContainer/Restart/ResLight.set_enemy_visible(false)
	$CenterContainer/VBoxContainer/MainMenu/MenuLight.set_enemy_visible(false)
	
	update_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func show():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$music.play()
	$CenterContainer.show()


func _input(event):
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
			if(pos==0 && $CenterContainer/VBoxContainer/Restart/ResLight.is_visible_in_tree()):
				_on_Restart_pressed()
			if(pos==1 && $CenterContainer/VBoxContainer/MainMenu/MenuLight.is_visible_in_tree()):
				_on_MainMenu_pressed()

func _closeBeforeChange():
	if(pos==0):
		_on_Restart_mouse_exited()
	if(pos==1):
		_on_MainMenu_mouse_exited()

func _closeBefore():
	if(pos==0):
		$CenterContainer/VBoxContainer/Restart/ResLight.hide()
		_on_Restart_mouse_exited()
	if(pos==1):
		$CenterContainer/VBoxContainer/MainMenu/MenuLight.hide()
		_on_MainMenu_mouse_exited()

func _ChangePos():
	if(pos<=0):
		pos=0 
		_on_Restart_mouse_entered()
	if(pos>=1):
		pos=1 
		_on_MainMenu_mouse_entered()

func _on_Restart_pressed():
	$AudioClick.play()
	pos=-1
	$CenterContainer/VBoxContainer/Restart/ResLight.hide()
	get_tree().paused=false
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_RESTART)

func _on_Restart_mouse_entered():
	pos=0
	$CenterContainer/VBoxContainer/Restart/ResLight.enable()
	$CenterContainer/VBoxContainer/Restart/ResLight.show()


func _on_Restart_mouse_exited():
	$CenterContainer/VBoxContainer/Restart/ResLight.hide()


func _on_MainMenu_mouse_entered():
	pos=1
	$CenterContainer/VBoxContainer/MainMenu/MenuLight.show()
	$CenterContainer/VBoxContainer/MainMenu/MenuLight.enable()


func _on_MainMenu_mouse_exited():
	$CenterContainer/VBoxContainer/MainMenu/MenuLight.hide()


func _on_MainMenu_pressed():
	$AudioClick.play()
	pos=-1
	$CenterContainer/VBoxContainer/MainMenu/MenuLight.hide()
	get_tree().paused=false
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_MAIN_MENU)

func update_text():
	var _key = GlobalVars.Storage_string_id.MENU
	$CenterContainer/VBoxContainer/Label.text = textStorage.get_string(_key, "WindowGameOverLabel")
	$CenterContainer/VBoxContainer/Restart.text = textStorage.get_string(_key, "WindowGameOverRestart")
	$CenterContainer/VBoxContainer/MainMenu.text = textStorage.get_string(_key, "WindowGameOverMainExit")
