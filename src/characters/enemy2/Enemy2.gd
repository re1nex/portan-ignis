extends KinematicBody2D

class_name Enemy2

export (float) var fire_rate
export (PackedScene) var arrow
var vis_color = Color(.867, .91, .247, 0.1)
var laser_color = Color(1.0, .329, .298)

var target
var hit_pos
var can_shoot = true
var target_radius = 0
var radCoef = 0.25

func _ready():
	$ShootTimer.wait_time = fire_rate

func _physics_process(delta):
	if target:
		aim()
		update()

func aim():
	var pos = target.global_position
	hit_pos = [pos]
	var space_state = get_world_2d().direct_space_state
	if target_radius:
		hit_pos.append(pos + Vector2(0, radCoef * target_radius))
		hit_pos.append(pos - Vector2(0, radCoef * target_radius))
		hit_pos.append(pos + Vector2(radCoef * target_radius, 0))
		hit_pos.append(pos - Vector2(radCoef * target_radius, 0))
	for i in range(len(hit_pos)):
		var result = space_state.intersect_ray(position + $ArrowPos.position,
				hit_pos[i], [self], 1 << 2)
		if not result and can_shoot:
			shoot(pos)
			return

func shoot(where):
	var dir = where - position
	if dir.x < 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	if dir.x * $ArrowPos.position.x < 0:
		$ArrowPos.position.x *= -1
	var a_pos = global_position + $ArrowPos.position
	var b = arrow.instance()
	var a = (where - a_pos).angle() - 0.0015 * dir.x
	b.start(a_pos, a)
	get_parent().add_child(b)
	can_shoot = false
	$ShootTimer.start()

func _draw():
#	if hit_pos:
#		for hit in hit_pos:
#			draw_line(Vector2() + $ArrowPos.position, (hit - position), laser_color)
	pass

func _on_Visibility_area_entered(area):
	if target:
		return
	target = area
	var t = target.get_node('CollisionShape2D').shape
	if target.get_node('CollisionShape2D').shape is CircleShape2D:
		target_radius = target.get_node('CollisionShape2D').shape.radius
	else:
		target_radius = 0

func _on_Visibility_area_exited(area):
	if area == target:
		target = null

func _on_ShootTimer_timeout():
	can_shoot = true
