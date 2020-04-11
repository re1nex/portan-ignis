extends Node


func set_fullscreen(val):
	if Settings.Graphics["Fullscreen"] != val:
		Settings.Graphics["Fullscreen"] = val
		OS.window_fullscreen = val
		
func set_strecthing(val):
	if val != Settings.Graphics["Stretching"]:
		Settings.Graphics["Stretching"] = val
		match val:
			true:
				get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(1280, 720))
			false:
				get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, Vector2(1280, 720))
