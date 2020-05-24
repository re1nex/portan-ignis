extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var informator
var active = false
onready var weapons = get_node("Control/Types/Weapons/WeaponsGrid")
onready var instriments = get_node("Control/Types/Instruments/InstrumentsGrid")
# Called when the node enters the scene tree for the first time.
#func _ready():
#	$Control.hide()
#	pass # Replace with function body.


func _input(event):
	if event.is_action_pressed("ui_inventory"):
		if not active:
			$AudioOpen.play()
			active = true
			#update()
			$Control.show()
			get_tree().paused = true
			pause_mode = PAUSE_MODE_PROCESS
			
			update()
		else:
			$AudioClose.play()
			$Control.hide()
			clear()
			active = false
			get_tree().paused = false
			pause_mode = PAUSE_MODE_INHERIT

func set_player(player):
	informator = player.get_informator()

func update():
	#WEAPONS
	if informator.has_weapons[GlobalVars.Ignis_type.REGULAR]:
		var node = preload("res://src/ui/inventory/TextureRect.tscn").instance()
		node.set_picture("res://resource/sprites/ignis/ignis_regular_outer/torch.png")
		weapons.add_child(node)
	if informator.has_weapons[GlobalVars.Ignis_type.SECTOR]:
		var node = preload("res://src/ui/inventory/TextureRect.tscn").instance()
		node.set_picture("res://resource/sprites/ignis/ignis_sector_outer/lens.png")
		weapons.add_child(node)
	if informator.has_weapons[GlobalVars.Ignis_type.LONG_SECTOR]:
		var node = preload("res://src/ui/inventory/TextureRect.tscn").instance()
		node.set_picture("res://resource/sprites/ignis/ignis_long_sector_outer/long_sector_oriented.png")
		weapons.add_child(node)
	
	#INSTRUMENTS
	for i in range(informator.has_instruments[GlobalVars.Instruments_type.LEVER]):
		var node = preload("res://src/ui/inventory/TextureRect.tscn").instance()
		node.set_picture("res://resource/sprites/objects/lever/DungeonCrawl_ProjectUtumnoTileset.png")
		instriments.add_child(node)
	
	for i in range(informator.has_instruments[GlobalVars.Instruments_type.GREANDE]):
		var node = preload("res://src/ui/inventory/TextureRect.tscn").instance()
		node.set_picture("res://resource/sprites/objects/grenade/grenade_inv.png")
		instriments.add_child(node)


func clear():
	var childs = weapons.get_children()
	for i in childs:
		weapons.remove_child(i)
	
	childs = instriments.get_children()
	for i in childs:
		instriments.remove_child(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
