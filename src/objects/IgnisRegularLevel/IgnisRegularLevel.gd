extends Area2D

signal active
signal not_active

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const radius_multiplier = 1.5
const energy_levels = [0, 0.70, 0.80, 0.90, 1.00] # default for ignis level
const scale_levels = [0, 0.60, 0.75, 0.85, 1.00] # default for ignis level

export (String, "simple", "column", "post") var type
export (bool) var activated_at_start = false
var body_informator = null
var health


func _init():
	health = GlobalVars.Ignis_state.OFF
# Called when the node enters the scene tree for the first time.


func _ready():
	
	if type == "column":
		$TorchSprite.hide()
		$ColumnSprite.show()
	elif type == "post":
		$TorchSprite.hide()
		$PostSprite.show()
	
	$Light2D.init_radius(radius_multiplier)
	$Light2D.set_health_params(scale_levels, energy_levels)
	if activated_at_start:
		health = GlobalVars.Ignis_state.LIFE_MAX
		$AudioLoop.play()
		$Light2D.enable()
		emit_signal("active")
	else:
		health = GlobalVars.Ignis_state.OFF
		$Light2D.disable()
		emit_signal("not_active")
	pass # Replace with function body.


func activate_at_start():
	$Light2D.enable()
	emit_signal("active")


func activate():
	if health != GlobalVars.Ignis_state.OFF:
		$AudioLoop.stop()
		$AudioOff.play()
		$Light2D.disable()
		health = GlobalVars.Ignis_state.OFF
		emit_signal("not_active")
	elif body_informator != null and body_informator.ignis_status == GlobalVars.Is_ignis.HAS_IGNIS:
		$AudioOff.stop()
		$AudioOn.play()
		$AudioLoop.play()
		health = body_informator.ignis_health
		$Light2D.reload(body_informator.ignis_health)
		$Light2D.enable()
		emit_signal("active")


func _on_IgnisRegularLevel_body_entered(body):
	if body.has_method("get_informator"):
		body_informator = body.get_informator()
	pass # Replace with function body.


func _on_IgnisRegularLevel_body_exited(body):
	if body.has_method("get_informator"):
		if body.get_informator() == body_informator:
			body_informator = null
	pass # Replace with function body.


func hit():
	var need_switch_off = (max(min(health, health - 1), 0) == 0 and health != 0)
	$Light2D.hit()
	if health != $Light2D.health and $Light2D.health == GlobalVars.Ignis_state.OFF:
		activate()
	health = $Light2D.health


func reload(arg):
	var need_activate = (min(health, arg) == 0 and max(health, arg) != 0)
	$Light2D.reload(arg)
	health = $Light2D.health
	if need_activate:
		activate()
