extends CanvasLayer
var keyboard=false
var pos = -1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var en = $MarginContainer/CenterContainer/CenterContainer/Sprite/Restart/ResLight.Ignis_layer.MENU
	
	$MarginContainer/CenterContainer/CenterContainer/Sprite/Restart/ResLight.set_light_layer(en)
	$MarginContainer/CenterContainer/CenterContainer/Sprite/MainMenu/MenuLight.set_light_layer(en)
	
	$MarginContainer/CenterContainer/CenterContainer/Sprite/Restart/ResLight.disable()
	$MarginContainer/CenterContainer/CenterContainer/Sprite/MainMenu/MenuLight.disable()

	$MarginContainer/CenterContainer/CenterContainer/Sprite/Restart/ResLight.set_enemy_visible(false)
	$MarginContainer/CenterContainer/CenterContainer/Sprite/MainMenu/MenuLight.set_enemy_visible(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _input(event):
	if($MarginContainer.is_visible_in_tree()):
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
			if(pos==0 && !$MarginContainer/CenterContainer/CenterContainer/Sprite/Restart/ResLight.switchingOff):
				_on_Restart_pressed()
			if(pos==1 && !$MarginContainer/CenterContainer/CenterContainer/Sprite/MainMenu/MenuLight.switchingOff):
				_on_MainMenu_pressed()

func _closeBeforeChange():
	if(pos==0):
		_on_Restart_mouse_exited()
	if(pos==1):
		_on_MainMenu_mouse_exited()

func _closeBefore():
	if(pos==0):
		$MarginContainer/CenterContainer/CenterContainer/Sprite/Restart/ResLight.hide()
		_on_Restart_mouse_exited()
	if(pos==1):
		$MarginContainer/CenterContainer/CenterContainer/Sprite/MainMenu/MenuLight.hide()
		_on_MainMenu_mouse_exited()

func _ChangePos():
	if(pos<=0):
		pos=0 
		_on_Restart_mouse_entered()
	if(pos>=1):
		pos=1 
		_on_MainMenu_mouse_entered()

func _on_Restart_pressed():
	pos=-1
	$MarginContainer/CenterContainer/CenterContainer/Sprite/Restart/ResLight.disable()
	$MarginContainer/CenterContainer/CenterContainer/Sprite/Restart/ResLight.hide()
	get_tree().paused=false
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_RESTART)

func _on_Restart_mouse_entered():
	pos=0
	$MarginContainer/CenterContainer/CenterContainer/Sprite/Restart/ResLight.enable()
	$MarginContainer/CenterContainer/CenterContainer/Sprite/Restart/ResLight.show()


func _on_Restart_mouse_exited():
	$MarginContainer/CenterContainer/CenterContainer/Sprite/Restart/ResLight.disable()


func _on_MainMenu_mouse_entered():
	pos=1
	$MarginContainer/CenterContainer/CenterContainer/Sprite/MainMenu/MenuLight.show()
	$MarginContainer/CenterContainer/CenterContainer/Sprite/MainMenu/MenuLight.enable()


func _on_MainMenu_mouse_exited():
	$MarginContainer/CenterContainer/CenterContainer/Sprite/MainMenu/MenuLight.disable()


func _on_MainMenu_pressed():
	pos=-1
	$MarginContainer/CenterContainer/CenterContainer/Sprite/MainMenu/MenuLight.disable()
	$MarginContainer/CenterContainer/CenterContainer/Sprite/MainMenu/MenuLight.hide()
	get_tree().paused=false
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_MAIN_MENU)
