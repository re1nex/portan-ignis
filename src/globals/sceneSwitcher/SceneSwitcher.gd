extends Node

enum Scenes{
	SCENE_STAGE_0,
	SCENE_STAGE_1,
	SCENE_STAGE_2,
	SCENE_STAGE_3,
	SCENE_STAGE_4,
	SCENE_STAGE_5,
	SCENE_STAGE_6,
	SCENE_MAIN_MENU,
	SCENE_RESTART,
	SCENE_NEXT_SCENE
}

var cur_scene

func _ready():
	cur_scene = Scenes.SCENE_MAIN_MENU
	

func goto_scene(scene):
	if scene == Scenes.SCENE_NEXT_SCENE:
		call_deferred("_deferred_goto_scene", cur_scene + 1)
	else:
		call_deferred("_deferred_goto_scene", scene)


func _deferred_goto_scene(scene):
	if scene != Scenes.SCENE_RESTART:
		 cur_scene = scene
		
	var new_scene
	if scene == Scenes.SCENE_STAGE_0:
		new_scene = ResourceLoader.load("res://src/levels/level0/Level0.tscn")
		Transfer.set_default_chars()
	elif scene == Scenes.SCENE_STAGE_1:
		new_scene = ResourceLoader.load("res://src/levels/level1/Level1.tscn")
		Transfer.set_default_chars()
	elif scene == Scenes.SCENE_STAGE_2:
		new_scene = ResourceLoader.load("res://src/levels/level2/Level2.tscn")
		if Transfer.levels_passed == 0:
			Transfer.set_default_level2_chars()
	elif scene == Scenes.SCENE_STAGE_3:
		new_scene = ResourceLoader.load("res://src/levels/level3/Level3.tscn")
		if Transfer.levels_passed == 0:
			Transfer.set_default_level3_chars()
	elif scene == Scenes.SCENE_STAGE_4:
		new_scene = ResourceLoader.load("res://src/levels/level4/Level4.tscn")
		if Transfer.levels_passed == 0:
			Transfer.set_default_level4_chars()
	elif scene == Scenes.SCENE_STAGE_5:
		new_scene = ResourceLoader.load("res://src/levels/level5/Level5.tscn")
		if Transfer.levels_passed == 0:
			Transfer.set_default_level5_chars()
	elif scene == Scenes.SCENE_STAGE_6:
		new_scene = ResourceLoader.load("res://src/levels/level6/Level6.tscn")
		if Transfer.levels_passed == 0:
			Transfer.set_default_level6_chars()
	elif scene == Scenes.SCENE_MAIN_MENU:
		new_scene = ResourceLoader.load("res://src/ui/mainMenu/MainMenuView.tscn")
		Transfer.set_default_chars()
	elif scene == Scenes.SCENE_RESTART:
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
