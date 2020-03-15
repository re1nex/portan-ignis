extends MarginContainer


const InformatorClass = preload("res://player/Informator.gd")
const PlayerClass = preload("res://player/Player.gd")


var informator
var health
var torch_lives
var player


func _ready():
	pass


func init_player(plr):
	player = plr
	informator = player.get_informator()
	set_health_bar(informator.health)	
	set_ignis_bar(informator.ignis_timer_start)


func _process(delta):
	set_health_bar(informator.health)
	set_ignis_bar(informator.ignis_timer_start)
	


func set_ignis_bar(value):
	if informator.ignis_status == informator.Is_ignis.NO_IGNIS:
		$MainContainer/Bars/Bar/torchStatus.value = 0
	else:
		$MainContainer/Bars/Bar/torchStatus.value = value


func set_health_bar(lives):
	if lives >= 1:
		$MainContainer/Heart1.value = 1
	else:
		$MainContainer/Heart1.value = 0
	if lives >= 2:
		$MainContainer/Heart2.value = 1
	else:
		$MainContainer/Heart2.value = 0
	if lives >= 3:
		$MainContainer/Heart3.value = 1
	else:
		$MainContainer/Heart3.value = 0
	if lives >= 4:
		$MainContainer/Heart4.value = 1
	else:
		$MainContainer/Heart4.value = 0
	if lives >= 5:
		$MainContainer/Heart5.value = 1
	else:
		$MainContainer/Heart5.value = 0
