extends MarginContainer


const fading_delta = 0.1
const max_ignis_bar_value = 1
const ignis_bars_count = 4

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
	self.show()
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
	player.connect("torch_hit", self, "_on_torch_hit")
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
	max_alpha = $MainContainer/TBCenterContainer/torchBars/Bar1.modulate.a
	min_alpha = 0
	if old_status == GlobalVars.Is_ignis.NO_IGNIS:
		pb_hide_all()


func pb_hide_all():
	for ind in range(ignis_bars_count):
		var pb_cur = get_ignis_bar_by_number(ind)
		pb_cur.modulate.a = 0


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
	$MainContainer/ChosenIgnis/LongSector.hide()


func status_set_torch():
	$MainContainer/ChosenIgnis/Sector.hide()
	$MainContainer/ChosenIgnis/Torch.show()
	$MainContainer/ChosenIgnis/LongSector.hide()


func status_set_long_sector():
	$MainContainer/ChosenIgnis/Sector.hide()
	$MainContainer/ChosenIgnis/Torch.hide()
	$MainContainer/ChosenIgnis/LongSector.show()


func status_set_none():
	$MainContainer/ChosenIgnis/Sector.hide()
	$MainContainer/ChosenIgnis/Torch.hide()
	$MainContainer/ChosenIgnis/LongSector.hide()


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
		2:
			status_set_long_sector()
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
		pb_fading_in_anim()
	else:
		pb_fading_out_anim()


func pb_fading_in_anim():
	for pb_ind in range(ignis_bars_count):
		var current_bar = get_ignis_bar_by_number(pb_ind)
		current_bar.modulate.a += fading_delta
		if current_bar.modulate.a >= max_alpha:
			current_bar.modulate.a = max_alpha
			progress_bar_fading = false


func pb_fading_out_anim():
	for pb_ind in range(ignis_bars_count):
		var current_bar = get_ignis_bar_by_number(pb_ind)
		current_bar.modulate.a -= fading_delta
		if current_bar.modulate.a <= min_alpha:
			current_bar.modulate.a = min_alpha
			progress_bar_fading = false


func set_ignis_bar(value):
	#if value == max_ignis_bar_value:
	#	fill_ignis_health_full(ignis_bars_count)
	#else:
		var cur_ignis_health = informator.ignis_health
		var current_bar = get_ignis_bar_by_number(cur_ignis_health - 1) # starts with 0 
		if current_bar == null: # ignis is OFF completely
			fill_ignis_health_full(0)
			ignis_bar_changing = false
			return
		fill_ignis_health_full(cur_ignis_health)
		if current_bar.value == value and value == 0:
			ignis_bar_changing = false
		else:
			ignis_bar_changing = true
		if informator.ignis_status == GlobalVars.Is_ignis.NO_IGNIS:
			fill_ignis_health_full(0) # make all bars empty
			ignis_bar_changing = false
		else:
			current_bar.value = value


func get_ignis_bar_by_number(num):
	match num:
		0:
			return $MainContainer/TBCenterContainer/torchBars/Bar1
		1:
			return $MainContainer/TBCenterContainer/torchBars/Bar2
		2:
			return $MainContainer/TBCenterContainer/torchBars/Bar3
		3:
			return $MainContainer/TBCenterContainer/torchBars/Bar4


func fill_ignis_health_full(full_cnt):
	if full_cnt >= 1:
		$MainContainer/TBCenterContainer/torchBars/Bar1.value = max_ignis_bar_value
	else:
		$MainContainer/TBCenterContainer/torchBars/Bar1.value = 0
	if full_cnt >= 2:
		$MainContainer/TBCenterContainer/torchBars/Bar2.value = max_ignis_bar_value
	else:
		$MainContainer/TBCenterContainer/torchBars/Bar2.value = 0
	if full_cnt >= 3:
		$MainContainer/TBCenterContainer/torchBars/Bar3.value = max_ignis_bar_value
	else:
		$MainContainer/TBCenterContainer/torchBars/Bar3.value = 0
	if full_cnt >= 4:
		$MainContainer/TBCenterContainer/torchBars/Bar4.value = max_ignis_bar_value
	else:
		$MainContainer/TBCenterContainer/torchBars/Bar4.value = 0
	pass


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


func _on_torch_hit():
	ignis_bar_changing=true
	set_process(true)
	pass
