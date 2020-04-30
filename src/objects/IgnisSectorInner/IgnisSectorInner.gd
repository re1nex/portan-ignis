extends Light2D

const deltaScale = 0.001
const deltaScaleCircle = 0.1 # circle postfix means it's for circle light2D
const energyDec = 0.025
const energyMin = 0.1
const default_health = GlobalVars.Ignis_state.LIFE_MAX
const health_to_index = {
	GlobalVars.Ignis_state.OFF: 0,
	GlobalVars.Ignis_state.LIFE_1: 1,
	GlobalVars.Ignis_state.LIFE_2: 2,
	GlobalVars.Ignis_state.LIFE_3: 3,
	GlobalVars.Ignis_state.LIFE_MAX: 4,
}
const index_to_health = [
	GlobalVars.Ignis_state.OFF,
	GlobalVars.Ignis_state.LIFE_1,
	GlobalVars.Ignis_state.LIFE_2,
	GlobalVars.Ignis_state.LIFE_3,
	GlobalVars.Ignis_state.LIFE_MAX,
]
const energy_levels = [0, 0.40, 0.60, 0.80, 1.00] # default for sector
const scale_levels = [0, 0.70, 0.83, 0.93, 1.00] # default for sector

var reflected = 1

var minScale
var minScaleCircle
var energyMax
var switchingOff
var health = default_health
var true_scale # when the health is max (start values)
var true_energy
var true_area2D_scale
var last_health # to restore health after switching off
var enable_in_process
var hit_time = 1

var priority = 1


func _ready():
	minScale = texture_scale
	minScaleCircle = $Circle.texture_scale
	rotate(PI / 2)
	energyMax = 1.2
	switchingOff = false
	last_health = health
	true_scale = minScale
	true_area2D_scale = $Area2D.scale
	true_energy = energyMax
	finishDisabling()
	
	pass # Replace with function body.


func _process(delta):
	texture_scale = minScale + float(randf() * deltaScale/ (minScale))
	$Circle.texture_scale = minScaleCircle + float(randf() * deltaScaleCircle/ (minScaleCircle))
	if switchingOff and not health == GlobalVars.Ignis_state.OFF:
		# switching off is in process
		energy -= energyDec
		$Circle.energy -= energyDec
		checkEnergy()
	if not switchingOff and enable_in_process:
		# light needs to be switched on
		finishEnabling()


func mirror():
	reflected = - reflected
	rotation = -rotation
	clamp_rotation()
	pass


func clamp_rotation():
	# rotation must be in [-PI; PI]
	if rotation <= -PI:
		rotation = -PI
	if rotation > PI:
		rotation = PI


func rotate_ignis(val):
	val *= reflected
	if reflected * (rotation + val) < 0:
		# val changes rotation sign
		rotation = 0 # border value
		return
	rotation += val
	clamp_rotation()
	pass


func checkEnergy():
	if energy <= energyMin:
		finishDisabling()
		health = GlobalVars.Ignis_state.OFF


func disable():
	switchingOff = true
	enable_in_process = false


func finishDisabling():
	$Area2D/CollisionShape2D.disabled = true
	$Area2D/Circle.disabled = true
	$Lens.hide()
	enabled = false
	$Circle.enabled = false
	$Circle.energy = 0
	energy = 0
	last_health = health
	health = GlobalVars.Ignis_state.OFF
	set_process(false)


func enable():
	if last_health != GlobalVars.Ignis_state.OFF:
		switchingOff = false
		energy = energyMax
		$Circle.energy = energyMax
		set_process(true)
		enable_in_process = true


func finishEnabling():
	health = last_health
	$Area2D/CollisionShape2D.disabled = false
	$Area2D/Circle.disabled = false
	$Lens.show()
	enabled = true
	$Circle.enabled = true
	energy = energyMax
	$Circle.energy = energyMax


func set_state():
	var ind = health_to_index[health]
	if ind == 0:
		_handle_state_off()
		pass
	else:
		_set_state_by_params(scale_levels[ind], energy_levels[ind])


func _handle_state_off():
	switchingOff = true
	finishDisabling()
	set_process(false)


func _set_state_by_params(scale_part, energy_part):
	minScale = true_scale * scale_part - 0.01
	energyMax = true_energy * energy_part
	$Area2D.scale = true_area2D_scale * scale_part
	energy = energyMax
	$Circle.energy = energyMax


func hit():
	if $TimerHit.is_stopped():
		var ind = health_to_index[health]
		if ind > 0:
			ind -= 1
		reload(index_to_health[ind])
		turn_on_hit_timer()


func turn_on_hit_timer():
	$TimerHit.set_wait_time(hit_time)
	$TimerHit.start()

# source state is GlobalVars.Ignis_state enum
func reload(source_state = GlobalVars.Ignis_state.LIFE_MAX):
	health = source_state
	last_health = health
	set_state()


func get_health():
	return health


func _on_TimerHit_timeout():
	pass # Replace with function body.
