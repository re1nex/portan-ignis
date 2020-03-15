extends Node

enum Scenes{
	SCENE_STAGE_1,
	SCENE_STAGE_TEST,
	SCENE_MAIN_MENU,
}

var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)


func goto_scene(scene):
	call_deferred("_deferred_goto_scene", scene)


func _deferred_goto_scene(scene):
	var new_scene
	
	if (scene == Scenes.SCENE_STAGE_1):
		new_scene = ResourceLoader.load("res://level1/Level1.tscn")
	elif (scene == Scenes.SCENE_STAGE_TEST):
		new_scene = ResourceLoader.load("res://Main/Main.tscn")
	elif (scene == Scenes.SCENE_MAIN_MENU):
		new_scene = ResourceLoader.load("res://mainMenu/MainMenuView.tscn")
	else:
		return
	
	current_scene.free()
	current_scene = new_scene.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
