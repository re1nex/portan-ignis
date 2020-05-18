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
	_fill_hint1()
	pass


func _fill_hint1():
	$Hint.text = textStorage.get_string(GlobalVars.Storage_string_id.HINT, "Hint1")
	$Hint.upd_text()
	$HintTorch.text = textStorage.get_string(GlobalVars.Storage_string_id.HINT, "HintTorch")
	$HintTorch.upd_text()


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
