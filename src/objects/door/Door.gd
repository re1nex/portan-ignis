extends KinematicBody2D


var height = 0
var step = 0
var max_height
export var SPEED = 60
var linear_vel = Vector2()
var src_size
var bodies_below = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	src_size = $CollisionShape2D.shape.extents.y
	max_height = $CollisionShape2D.shape.extents.y * 2
	pass # Replace with function body.

func _process(delta):
	if step != 0:
		var del = position.y
		if (linear_vel.y < 0 or bodies_below == 0):
			move_and_collide(linear_vel * delta)
		del -= position.y
		if del < 0:
			$CollisionShape2D.shape.extents.y += del 
		height += del
		if height > max_height:
			position.y += height - max_height
			height -= height - max_height
			step = 0
		elif height < 0:
			position.y += height
			height = 0
			step = 0
	pass
	#update()


func _on_IgnisRegularLevel_active():
	$CollisionShape2D.shape.extents.y = src_size
	linear_vel.y = -SPEED
	step = -SPEED
	pass # Replace with function body.


func _on_IgnisRegularLevel_not_active():
	linear_vel.y = SPEED
	step = SPEED
	if bodies_below == 0:
		$CollisionShape2D.shape.extents.y += height
	pass # Replace with function body.

#func _draw():
#	var s = $CollisionShape2D.shape.extents
#	var pos = $CollisionShape2D.position
#	var r = Rect2(Vector2(pos.x - s.x, pos.y - s.y), s * 2)
#	var r2 = Rect2(- $SearchArea/SearchShape.shape.extents + $SearchArea/SearchShape.position, 2 * $SearchArea/SearchShape.shape.extents )
#	draw_rect(r, Color(0.960784, 0, 0))
#	draw_rect(r2, Color(0.9, 0.9, 0))


func _on_SearchArea_body_entered(body):
	if body.get_name() != 'TileMap':
		bodies_below += 1
	pass # Replace with function body.


func _on_SearchArea_body_exited(body):
	if body.get_name() != 'TileMap':
		bodies_below -= 1
	pass # Replace with function body.

