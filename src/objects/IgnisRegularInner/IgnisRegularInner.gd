extends Light2D

const deltaScale = 0.0025
const energyDec = 0.025
const energyMin = 0.1

var minScale
var energyMax
var switchingOff
var switchedOff

var priority = 1

var reflected = 1

var enemy_visible = true

enum Ignis_layer{
	STAGE,
	MENU
}

# Called when the node enters the scene tree for the first time.
func _ready():
	minScale = texture_scale - 0.01
	energyMax = 1.2
	switchingOff = false
	switchedOff = true
	finish_disabling()
	set_process(false)
	set_visibility_flags(true)
	pass # Replace with function body

# Called in ignisRegularLevel and ...Outer to increase radiuses
func init_radius(mul):
	texture_scale *= mul
	$Area2D.scale *= mul
	minScale = texture_scale - 0.01
	$VisibilityEnabler2D.scale *= mul


func set_light_layer(layer):
	if layer == Ignis_layer.STAGE:
		shadow_item_cull_mask = 1 << 0
		$Flame.light_mask = 1 << 0
		range_item_cull_mask = 1 << 1
	elif layer == Ignis_layer.MENU:
		shadow_item_cull_mask = 1 << 1
		$Flame.light_mask = 1 << 1
		range_item_cull_mask = 1 << 1


func set_enemy_visible(vis):
	enemy_visible = vis
	if enemy_visible == false:
		$Area2D/CollisionShape2D.disabled = true


func _process(delta):
	texture_scale = minScale + float(randf() / (minScale + deltaScale))
	if switchingOff and not switchedOff:
		# switching off is in process
		energy -= energyDec
		checkEnergy()
	if not switchingOff and switchedOff:
		# light needs to be switched on
		finish_enabling()


func checkEnergy():
	if energy <= energyMin:
		finish_disabling()
		set_process(false)
		set_visibility_flags(false)
		switchedOff = true


func disable():
	switchingOff = true


func finish_disabling():
	if enemy_visible == true:
		$Area2D/CollisionShape2D.disabled = true
	$Flame.emitting = false
	$Smoke.emitting = false
	enabled = false
	energy = 0
	switchedOff = true


func enable():
	switchingOff = false
	energy = energyMax
	set_process(true)
	set_visibility_flags(true)


func finish_enabling():
	switchedOff = false
	$Flame.emitting = true
	$Smoke.emitting = true
	if enemy_visible == true:
		$Area2D/CollisionShape2D.disabled = false
	enabled = true
	energy = energyMax


func mirror():
	reflected *= -1
	pass


func rotate_ignis(degree):
	pass


func set_visibility_flags(val):
	$VisibilityEnabler2D.process_parent = val
	$VisibilityEnabler2D.pause_particles = val
