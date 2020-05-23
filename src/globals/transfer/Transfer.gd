extends Node


var health 
var cur_ignis_num
var cur_ignis_status
var weapons = []
var instruments = []
var ignis_health
const WEAPONS_NUM = 3#load("res://src/characters/player/Player.gd").WEAPONS_NUM
const INSTRUMENTS_NUM = 1

var levels_passed


func _ready():
	set_default_chars()


func set_default_chars():
	health = 5
	cur_ignis_num = -1
	cur_ignis_status = GlobalVars.Is_ignis.NO_IGNIS
	
	for i in range(WEAPONS_NUM):
		weapons.append(false)
		
	for i in range(INSTRUMENTS_NUM):
		instruments.append(0)
		
	levels_passed = 0
	ignis_health = GlobalVars.Ignis_state.LIFE_MAX


func set_default_level2_chars():
	health = 4
	cur_ignis_num = 0
	cur_ignis_status = GlobalVars.Is_ignis.HAS_IGNIS
	
	for i in range(WEAPONS_NUM):
		weapons.append(false)
	weapons[GlobalVars.Ignis_type.REGULAR] = true
		
	for i in range(INSTRUMENTS_NUM):
		instruments.append(0)
		
	levels_passed = 0
	ignis_health = GlobalVars.Ignis_state.LIFE_MAX


func set_default_level3_chars():
	health = 4
	cur_ignis_num = 0
	cur_ignis_status = GlobalVars.Is_ignis.HAS_IGNIS
	
	for i in range(WEAPONS_NUM):
		weapons.append(false)
	weapons[GlobalVars.Ignis_type.REGULAR] = true
		
	for i in range(INSTRUMENTS_NUM):
		instruments.append(0)
		
	levels_passed = 0
	ignis_health = GlobalVars.Ignis_state.LIFE_MAX


func set_default_level4_chars():
	health = 5
	cur_ignis_num = 0
	cur_ignis_status = GlobalVars.Is_ignis.HAS_IGNIS
	
	for i in range(WEAPONS_NUM):
		weapons.append(false)
	weapons[GlobalVars.Ignis_type.REGULAR] = true
		
	for i in range(INSTRUMENTS_NUM):
		instruments.append(0)
		
	levels_passed = 0
	ignis_health = GlobalVars.Ignis_state.LIFE_3


func set_default_level5_chars():
	health = 4
	cur_ignis_num = 0
	cur_ignis_status = GlobalVars.Is_ignis.HAS_IGNIS
	
	for i in range(WEAPONS_NUM):
		weapons.append(false)
	weapons[GlobalVars.Ignis_type.REGULAR] = true
		
	for i in range(INSTRUMENTS_NUM):
		instruments.append(0)
		
	levels_passed = 0
	ignis_health = GlobalVars.Ignis_state.LIFE_MAX


func set_default_level6_chars():
	health = 4
	cur_ignis_num = 0
	cur_ignis_status = GlobalVars.Is_ignis.HAS_IGNIS
	
	for i in range(WEAPONS_NUM):
		weapons.append(false)
	weapons[GlobalVars.Ignis_type.REGULAR] = true
	weapons[GlobalVars.Ignis_type.SECTOR] = true
		
	for i in range(INSTRUMENTS_NUM):
		instruments.append(0)
		
	levels_passed = 0
	ignis_health = GlobalVars.Ignis_state.LIFE_3


func copy_chars(player):
	var info
	if player.has_method("get_informator"):
		info = player.get_informator()
	else:
		return
	health = info.health
	cur_ignis_num = info.num_of_active_weapon
	cur_ignis_status = info.ignis_status
	if cur_ignis_status == GlobalVars.Is_ignis.HIDE_IGNIS:
		cur_ignis_status = GlobalVars.Is_ignis.NO_IGNIS
	
	for i in range(WEAPONS_NUM):
		weapons[i] = info.has_weapons[i]
		
	for i in range(INSTRUMENTS_NUM):
		instruments[i] = info.has_instruments[i]
		
	levels_passed += 1
	ignis_health = info.ignis_health
