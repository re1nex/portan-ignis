extends Node2D


var cur_height = 0
var closed_pos = Vector2(0, 0)
var opened_pos = Vector2(0, 0)
export var SPEED = 32	# pixels per second
export var OPENED = false
var cur_speed = 0
var bodies_below = 0


func _ready():
	opened_pos.y = -$Sprite.texture.get_height()
	if OPENED:
		$HardDoor/HardDoor.set_deferred("disabled", true)
		$Sprite.position = opened_pos
	set_process(false)
	pass

#func _pro(delta):
#	if step != 0:
#		var del = position.y
#		if (linear_vel.y < 0 or bodies_below == 0):
#			move_and_collide(linear_vel * delta)
#			del -= position.y
#			if del < 0:
#				$CollisionShape2D.shape.extents.y += del / 2
#			height += del
#		if height > max_height:
#			$CollisionShape2D.shape.extents.y = src_size 
#			position.y += height - max_height
#			height -= height - max_height
#			step = 0
#		elif height <= 0:
#			$CollisionShape2D.shape.extents.y = src_size
#			position.y += height
#			height = 0
#			step = 0
#	pass
#	update()


func _process(delta):
	if bodies_below == 0:
		if cur_speed < 0:
			if $Sprite.position == opened_pos:
				OPENED = true
				$HardDoor/HardDoor.set_deferred("disabled", true)
				cur_speed = 0
				stop_process()
				return
			else:
				var step = max(delta * cur_speed, opened_pos.y - $Sprite.position.y)
				$Sprite.position.y += step
				return
		else:
			if $Sprite.position == closed_pos:
				OPENED = false
				cur_speed = 0
				stop_process()
				return
			else:
				var step = min(delta * cur_speed, closed_pos.y - $Sprite.position.y)
				$Sprite.position.y += step
				return


func _on_IgnisRegularLevel_active():
	cur_speed = -SPEED
	set_process(true)
	$AudioLoop.play()
	pass


func _on_IgnisRegularLevel_not_active():
	if bodies_below == 0:
		$HardDoor/HardDoor.set_deferred("disabled", false)
	cur_speed = SPEED
	set_process(true)
	$AudioLoop.play()
	pass


func _on_Mechanism_active(time):
	cur_speed = -(opened_pos - closed_pos).length() / time
	set_process(true)
	$AudioLoop.play()
	pass


func _on_Mechanism_not_active(time):
	cur_speed = (opened_pos - closed_pos).length() / time
	set_process(true)
	$AudioLoop.play()
	pass


#func _draw():
#	var s = $CollisionShape2D.shape.extents
#	var pos = $CollisionShape2D.position
#	var r = Rect2(Vector2(pos.x - s.x, pos.y - s.y), s * 2)
#	var r2 = Rect2(- $SearchArea/SearchShape.shape.extents + $SearchArea/SearchShape.position, 2 * $SearchArea/SearchShape.shape.extents )
#	draw_rect(r, Color(0.960784, 0, 0))
#	draw_rect(r2, Color(0.9, 0.9, 0))


func _on_UnderGate_body_entered(body):
	bodies_below += 1
	pass


func _on_UnderGate_body_exited(body):
	bodies_below -= 1
	if cur_speed != 0 and bodies_below == 0:
		$HardDoor/HardDoor.set_deferred("disabled", false)
	pass


func stop_process():
	$AudioLoop.stop()
	$AudioLoop.seek(0)
	set_process(false)
