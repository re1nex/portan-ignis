extends KinematicBody2D

class_name Enemy2

export (float) var fire_rate
export (PackedScene) var arrow
var vis_color = Color(.867, .91, .247, 0.1)
var laser_color = Color(1.0, .329, .298)

var targets = []
var recent_target
var hit_pos
var can_shoot = true
var radCoef = 0.25
var idle = true

func _ready():
	$ShootTimer.wait_time = fire_rate

func _physics_process(delta):
	if targets:
		idle = false
		aim()
		update()
	else:
		idle = true

func aim():
	var space_state = get_world_2d().direct_space_state
	get_positions()
	for i in range(len(hit_pos)):
		var res = space_state.intersect_ray(hit_pos[0], hit_pos[i], [self], 1 << 2)
		var result = space_state.intersect_ray(position + $ArrowPos.position, hit_pos[i], [self], 1 << 2)
		if not result.size() and not res.size() and can_shoot:
			shoot(hit_pos[i])
			return

func shoot(where):
	var dir = where - position
	if dir.x < 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	if dir.x * $ArrowPos.position.x < 0:
		$ArrowPos.position.x *= -1
	var a_pos = position + $ArrowPos.position
	dir = where - a_pos
	var b = arrow.instance()
	var v = b.speed
	var g = b.gravity
	var k = (sqrt(pow(v,4) + 2 * dir.y * g * v * v - pow(dir.x, 2) * g * g) - v * v) / (dir.x * g)
	var a = atan(k) + rand_range(-0.05, 0.05)
	if dir.x < 0:
		a += PI
	b.start(a_pos, a)
	get_parent().add_child(b)
	can_shoot = false
	$ShootTimer.start()


func get_positions():
	recent_target = targets[0]
	var pos = targets[0].global_position
	var sc = targets[0].get_parent().scale
	var target_shape = targets[0].get_node('CollisionShape2D').shape
	hit_pos = [pos]
	if target_shape is CircleShape2D:
		var rad = target_shape.radius
		hit_pos.append(pos + Vector2(0, radCoef * rad))
		hit_pos.append(pos - Vector2(0, radCoef * rad))
		hit_pos.append(pos + Vector2(radCoef * rad, 0))
		hit_pos.append(pos - Vector2(radCoef * rad, 0))
	elif target_shape is ConvexPolygonShape2D:
		for p1 in target_shape.points:
			if p1 != Vector2.ZERO:
				hit_pos.append(pos + sc * p1.rotated(targets[0].get_parent().rotation))
			for p2 in target_shape.points:
				if p1 != p2:
					hit_pos.append(pos + ((p1 + p2) / 2 * sc).rotated(targets[0].get_parent().rotation))
#		target_radius = 0
	
func _draw():
	#if hit_pos:
	#	for hit in hit_pos:
	#		draw_line(Vector2() + $ArrowPos.position, (hit - position), laser_color)
	pass

func _on_Visibility_area_entered(area):
	var pr = area.get_parent().priority
	if pr == 1:
		targets.push_back(area)
	else:
		var i = 0
		while (i < targets.size() and targets[i].get_parent().priority > pr):
			i += 1
		if i == targets.size():
			targets.push_back(area)
		else:
			targets.insert(i, area)
	

func _on_Visibility_area_exited(area):
	targets.erase(area)
	if recent_target == area:
		recent_target = null
		hit_pos = null


func _on_ShootTimer_timeout():
	can_shoot = true


func _on_TurnTimer_timeout():
	if idle:
		$Sprite.flip_h = not $Sprite.flip_h
		$ArrowPos.position.x *= -1
