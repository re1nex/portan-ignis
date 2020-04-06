extends MarginContainer


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
var ignis_bar_changing


func _ready():
	$MainContainer/ChosenIgnis/Sector.hide()
	$MainContainer/ChosenIgnis/Torch.hide()
	ignis_bar_changing = false
	set_process(false)
	pass


func init_player(plr):
	player = plr
	informator = player.get_informator()
	set_health_bar(informator.health)
	set_ignis_bar(informator.ignis_timer_start)
	init_ignis_bar_anim()
	upd_chosen_ignis(informator.num_of_active_weapon)
	# connect signals
	player.connect("health_changed", self, "_on_health_changed")
	player.connect("torch_changed", self, "_on_torch_changed")
	player.connect("torch_reloaded", self, "_on_torch_reloaded")
	player.connect("torch_hidden", self, "_on_torch_hidden")


func _on_health_changed():
	set_health_bar(informator.health)
	pass


func _on_torch_changed():
	upd_chosen_ignis(informator.num_of_active_weapon)
	if old_status == GlobalVars.Is_ignis.NO_IGNIS:
		set_process(true)
	pass


func _on_torch_reloaded():
	ignis_bar_changing = true
	set_process(true) # process progress bar animation
	pass


func _on_torch_hidden():
	ignis_bar_changing = true
	set_process(true) # process progress bar animation
	pass


func init_ignis_bar_anim():
	old_status = informator.ignis_status
	progress_bar_fading = false
	fading_in = false 
	max_alpha = $MainContainer/torchStatus.modulate.a
	min_alpha = 0
	if old_status == GlobalVars.Is_ignis.NO_IGNIS:
		$MainContainer/torchStatus.modulate.a = 0 # hide


func _process(delta):
	set_ignis_bar(informator.ignis_timer_start)
	upd_ignis_bar(informator.ignis_status)
	ignis_bar_anim()
	process_switcher(informator.ignis_status) # switch off process


func process_switcher(ignis_status):
	if not ignis_bar_changing and old_status == ignis_status and not progress_bar_fading:
		set_process(false) # animations finished


func status_set_sector():
	$MainContainer/ChosenIgnis/Sector.show()
	$MainContainer/ChosenIgnis/Torch.hide()


func status_set_torch():
	$MainContainer/ChosenIgnis/Sector.hide()
	$MainContainer/ChosenIgnis/Torch.show()


func status_set_none():
	$MainContainer/ChosenIgnis/Sector.hide()
	$MainContainer/ChosenIgnis/Torch.hide()


func upd_chosen_ignis(active_weapon):
	if informator.ignis_status == GlobalVars.Is_ignis.NO_IGNIS:
		status_set_none()
		return
	match active_weapon:
		-1:
			status_set_none()
		0:
			status_set_torch()
		1: 
			status_set_sector()
	pass


func upd_ignis_bar(ignis_status):
	if ignis_status == old_status:
		return
	# status changed
	old_status = ignis_status # update status
	match ignis_status:
		GlobalVars.Is_ignis.NO_IGNIS:
			progress_bar_fading = true # to start animation
			fading_in = false # fading out
		_:
			progress_bar_fading = true # to start animation
			fading_in = true # fading in


func ignis_bar_anim():
	if not progress_bar_fading:
		return
	if fading_in:
		$MainContainer/torchStatus.modulate.a += fading_delta
		if $MainContainer/torchStatus.modulate.a >= max_alpha:
			$MainContainer/torchStatus.modulate.a = max_alpha
			progress_bar_fading = false # stop animation
	else:
		$MainContainer/torchStatus.modulate.a -= fading_delta
		if $MainContainer/torchStatus.modulate.a <= min_alpha:
			$MainContainer/torchStatus.modulate.a = min_alpha
			progress_bar_fading = false # stop animation


func set_ignis_bar(value):
	if $MainContainer/torchStatus.value != value:
		ignis_bar_changing = true
	else:
		ignis_bar_changing = false
	if informator.ignis_status == GlobalVars.Is_ignis.NO_IGNIS:
		$MainContainer/torchStatus.value = 0
	else:
		$MainContainer/torchStatus.value = value


func set_health_bar(lives):
	if lives >= 1:
		$MainContainer/Hearts/Heart1.value = 1
	else:
		$MainContainer/Hearts/Heart1.value = 0
	if lives >= 2:
		$MainContainer/Hearts/Heart2.value = 1
	else:
		$MainContainer/Hearts/Heart2.value = 0
	if lives >= 3:
		$MainContainer/Hearts/Heart3.value = 1
	else:
		$MainContainer/Hearts/Heart3.value = 0
	if lives >= 4:
		$MainContainer/Hearts/Heart4.value = 1
	else:
		$MainContainer/Hearts/Heart4.value = 0
	if lives >= 5:
		$MainContainer/Hearts/Heart5.value = 1
	else:
		$MainContainer/Hearts/Heart5.value = 0
