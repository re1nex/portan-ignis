extends Node2D

var posRD
var posLU

signal hint_activate
signal hint_disactivate
signal level_complete
signal player_stop
var begin = true


func _ready():
	posRD = $PositionRD.position
	posLU = $PositionLU.position
	
	$CanvasModulate.visible = true
	
	$Ignises/IgnisDoor.connect("active", $Door, "_on_IgnisRegularLevel_active")
	$Ignises/IgnisDoor.connect("not_active", $Door, "_on_IgnisRegularLevel_not_active")
	$Ignises/IgnisHint.connect("active", $HintTorch, "activate")
	pass

func _process(delta):
	if(begin):
		$Hint.activate()
		begin=false

func _on_LevelEnd_body_entered(body):
	if body.has_method("get_informator"):
		emit_signal("level_complete")


func _on_LevelEndStop_body_entered(body):
	if body.has_method("get_informator"):
		emit_signal("player_stop")


func _on_Hint_activate():
	emit_signal("hint_activate")


func _on_Hint_disactivate():
	emit_signal("hint_disactivate")
