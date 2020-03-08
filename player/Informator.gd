extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_ignis = false
var has_weapons = []
var num_of_active_weapon = - 1 # -1 - nothing is active

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(get_parent().WEAPONS_NUM):
		has_weapons.append(false)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
