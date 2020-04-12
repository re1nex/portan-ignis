extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var informator
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control.hide()
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_inventory"):
		if active:
			$Control.hide()
			clear()
			active = false
		else:
			update()
			$Control.show()
			active = true


func set_player(player):
	informator = player.get_informator()

func update():
	#WEAPONS
	if informator.has_weapons[GlobalVars.Ignis_type.REGULAR]:
		var node = preload("res://src/ui/inventory/TextureRect.tscn").instance()
		node.set_picture("res://resource/sprites/ignis/ignis_regular_outer/torch.png")
		$Control/GridContainer.add_child(node)
	if informator.has_weapons[GlobalVars.Ignis_type.SECTOR]:
		var node = preload("res://src/ui/inventory/TextureRect.tscn").instance()
		node.set_picture("res://resource/sprites/ignis/ignis_sector_outer/lens.png")
		$Control/GridContainer.add_child(node)
	
	#INSTRUMENTS
	if informator.has_instruments[GlobalVars.Instruments_type.LEVER]>0:
		var node = preload("res://src/ui/inventory/TextureRect.tscn").instance()
		node.set_picture("res://resource/sprites/objects/DungeonCrawl_ProjectUtumnoTileset.png")
		$Control/GridContainer.add_child(node)


func clear():
	var childs = $Control/GridContainer.get_children()
	for i in childs:
		$Control/GridContainer.remove_child(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
