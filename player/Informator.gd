extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum Is_ignis {
		HAS_IGNIS,
		HIDE_IGNIS,
		NO_IGNIS,
}

var ignis_status
var has_weapons = []
var num_of_active_weapon = - 1 # -1 - nothing is active
var timer_start

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(get_parent().WEAPONS_NUM):
		has_weapons.append(false)
	ignis_status = Is_ignis.NO_IGNIS
	timer_start = get_parent().LIFE_TIME_OF_IGNIS
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
