extends Node


var ignis_status
var has_weapons = []
var has_instruments = []
var num_of_active_weapon = - 1 # -1 - nothing is active
var ignis_timer_start
var health 


func _ready():
	for i in range(get_parent().WEAPONS_NUM):
		has_weapons.append(Transfer.weapons[i])
		
	for i in range(get_parent().INSTRUMENTS_NUM):
		has_instruments.append(Transfer.instruments[i])
	
	ignis_status = Transfer.cur_ignis_status
	ignis_timer_start = get_parent().life_time_of_ignis
	health = Transfer.health
	
	pass
