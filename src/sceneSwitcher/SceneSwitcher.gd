extends Node

enum Scenes{
	SCENE_STAGE_0,
	SCENE_STAGE_1,
	SCENE_MAIN_MENU,
	SCENE_RESTART
}

var strech = false

func goto_scene(scene):
	call_deferred("_deferred_goto_scene", scene)


func _deferred_goto_scene(scene):
	var new_scene
	if (scene == Scenes.SCENE_STAGE_0):
		new_scene = ResourceLoader.load("res://src/levels/level0/Level0.tscn")
	elif (scene == Scenes.SCENE_STAGE_1):
		new_scene = ResourceLoader.load("res://src/levels/level1/Level1.tscn")
	elif (scene == Scenes.SCENE_MAIN_MENU):
		new_scene = ResourceLoader.load("res://src/ui/mainMenu/MainMenuView.tscn")
	elif (scene == Scenes.SCENE_RESTART):
		get_tree().reload_current_scene()
		return
	else:
		return
	var current_scene = get_tree().get_current_scene()
	get_tree().get_root().remove_child(current_scene)
	current_scene.call_deferred("free")
	current_scene = new_scene.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
