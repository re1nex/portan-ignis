extends MarginContainer


const InformatorClass = preload("res://src/characters/player/Informator.gd")
const PlayerClass = preload("res://src/characters/player/Player.tscn")
const fading_delta = 0.1

var informator
var health
var torch_lives
var player
var old_status
var progress_bar_fading
var fading_in
var max_alpha
var min_alpha

func _ready():
	pass


func init_player(plr):
	player = plr
	informator = player.get_informator()
	set_health_bar(informator.health)	
	set_ignis_bar(informator.ignis_timer_start)
	init_ignis_bar_anim()


func init_ignis_bar_anim():
	old_status = informator.ignis_status
	progress_bar_fading = false
	fading_in = false 
	max_alpha = $MainContainer/Bars.modulate.a
	min_alpha = 0


func _process(delta):
	set_health_bar(informator.health)
	set_ignis_bar(informator.ignis_timer_start)
	upd_ignis_bar(informator.ignis_status)
	upd_chosen_ignis(informator.num_of_active_weapon)
	ignis_bar_anim()


func upd_chosen_ignis(active_weapon):
	if informator.ignis_status == informator.Is_ignis.NO_IGNIS:
		$MainContainer/ChosenIgnis/Status.text = "no ignis"
		return
	match active_weapon:
		-1:
			$MainContainer/ChosenIgnis/Status.text = "no ignis"
		0:
			$MainContainer/ChosenIgnis/Status.text = "torch"
		1: 
			$MainContainer/ChosenIgnis/Status.text = "lens"
	pass


func upd_ignis_bar(ignis_status):
	if ignis_status == old_status:
		return
	# status changed
	old_status = ignis_status # update status
	match ignis_status:
		informator.Is_ignis.NO_IGNIS:
			progress_bar_fading = true # to start animation
			fading_in = false # fading out
		_:
			progress_bar_fading = true # to start animation
			fading_in = true # fading in


func ignis_bar_anim():
	if not progress_bar_fading:
		return
	if fading_in:
		$MainContainer/Bars.modulate.a += fading_delta
		if $MainContainer/Bars.modulate.a >= max_alpha:
			progress_bar_fading = false # stop animation
	else:
		$MainContainer/Bars.modulate.a -= fading_delta
		if $MainContainer/Bars.modulate.a <= min_alpha:
			progress_bar_fading = false # stop animation


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
