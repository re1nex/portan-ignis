extends CanvasLayer
var keyboard=false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/CenterContainer/CenterContainer/Sprite/Ok/OkLight.range_layer_max=1
	$MarginContainer/CenterContainer/CenterContainer/Sprite/Ok/OkLight.range_layer_min=1
	$MarginContainer/CenterContainer/CenterContainer/Sprite/Ok/OkLight.disable()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _input(event):
	if($MarginContainer.is_visible_in_tree()):
		if event is InputEventMouseMotion:
			if(keyboard) :
				_on_Ok_mouse_exited()
				keyboard=false
		if event.is_action_pressed("ui_down"): 
			_on_Ok_mouse_entered()
			keyboard=true
		if event.is_action_pressed("ui_up"):
			_on_Ok_mouse_entered()
			keyboard=true
		if event.is_action_pressed("ui_cancel"):
			_on_Ok_pressed()
		if (event.is_action_pressed("ui_accept")&&!$MarginContainer/CenterContainer/CenterContainer/Sprite/Ok/OkLight.switchingOff):
			_on_Ok_pressed()

func _on_Ok_pressed():
	$MarginContainer/CenterContainer/CenterContainer/Sprite/Ok/OkLight.disable()
	$MarginContainer/CenterContainer/CenterContainer/Sprite/Ok/OkLight.hide()
	get_tree().paused=false
	$MarginContainer.hide()
	SceneSwitcher.goto_scene(SceneSwitcher.Scenes.SCENE_MAIN_MENU)


func _on_Ok_mouse_entered():
	$MarginContainer/CenterContainer/CenterContainer/Sprite/Ok/OkLight.enable()
	$MarginContainer/CenterContainer/CenterContainer/Sprite/Ok/OkLight.show()


func _on_Ok_mouse_exited():
	$MarginContainer/CenterContainer/CenterContainer/Sprite/Ok/OkLight.disable()
