extends KinematicBody2D

class_name Enemy1

var color = Color(.867, .91, .247, 0.1)
var lazerColor = Color(1, 0.007843, 0.007843, 0.9)
var greenColor = Color(0.015686, 0.996078, 0.215686)
const GRAVITY_VEC = Vector2(0, 1000)
export (int) var walk_speed = 100
export (int) var run_speed = 230
export (int) var jump_speed = 100
export (int) var JUMP_HEIGHT_LIMIT = 60
var direction = 1
var ex_direction
var velocity = Vector2()
const ROAMING = 0
const CHASING = 1 
const SMALL_RADIUS = 5
const FLOOR_NORMAL = Vector2(0, -1)
var can_jump = true
var vision_center
var mode = ROAMING
var targets = []
var recent_tar = null
var target_dir
var torch_area = null
var height = 0
var jumping = false
var player_target = null
var x_scale

# Called when the node enters the scene tree for the first time.
func _ready():
	#vision_center = Vector2(0, -$BodyShape.shape.height)
	vision_center = Vector2(0, 0)
	x_scale = $Visibility.scale.x
	pass

func _process(_delta):
	if player_target:
		$AnimatedSprite.animation = "slash"
		$AnimatedSprite.speed_scale = 0.25
		player_target.hit()

func _physics_process(delta):
	if torch_area and "activated" in torch_area and torch_area.activated:
		$AnimatedSprite.animation = "punch"
		torch_area.activate()
	check_chase()
	##  Moving logic  ##
	velocity += GRAVITY_VEC * delta
	velocity = move_and_slide(velocity, FLOOR_NORMAL, false, 4, 0.523598776)
	var on_floor = is_on_floor()
	if on_floor:
		height=0
	$AnimatedSprite.play()
	if mode == ROAMING:
		$AnimatedSprite.speed_scale = 2
		velocity.x = direction * walk_speed
		$AnimatedSprite.animation = "walk"
		if not $RayDownLeft.is_colliding() or $RayLeft.is_colliding():
			direction = 1.0
			$AnimatedSprite.flip_h = false
			$Visibility.scale.x = x_scale
		if not $RayDownRight.is_colliding() or $RayRight.is_colliding():
			direction = -1.0
			$AnimatedSprite.flip_h = true
			$Visibility.scale.x = -x_scale
	elif mode == CHASING:
		if abs(target_dir.x) < SMALL_RADIUS:
			ex_direction = direction
			direction = 0
			$AnimatedSprite.stop()
		else:
			$AnimatedSprite.speed_scale = 4
			if target_dir.x > 0:
				direction = 1
				$AnimatedSprite.flip_h = false
				$Visibility.scale.x = x_scale
			elif target_dir.x < 0:
				direction = -1
				$AnimatedSprite.flip_h = true
				$Visibility.scale.x = -x_scale
			else:
				ex_direction = direction
				direction = 0
				$AnimatedSprite.stop()
		var tar_tg = target_dir.y / target_dir.x
		if on_floor and target_dir.y < -SMALL_RADIUS and tar_tg < -0.92 and can_jump:
			can_jump = false
			$JumpTimer.start()
			$AnimatedSprite.animation = "jump"
			velocity.y = -jump_speed
			height -= velocity.y * delta
			jumping=true
		elif jumping==true:
			if $AnimatedSprite.animation != "slash":
				$AnimatedSprite.animation = "walk"
			if height < JUMP_HEIGHT_LIMIT and target_dir.y < -SMALL_RADIUS:
				velocity.y = -jump_speed
				height -= velocity.y * delta
			else:
				jumping=false
				#$AnimatedSprite.animation = "landing"
		velocity.x = direction * run_speed
	update()

func _draw():
#	if global_position:
#		draw_line(Vector2(0, 0), Vector2(20 * $Visibility.scale.x, 0), greenColor, 5)
#		if recent_tar != null:
#			draw_line(Vector2(0, 0), recent_tar.global_position - position, lazerColor, 10)
#		if targets:
#			for i in range(targets.size()):
#				draw_line(vision_center, targets[i].global_position - position, greenColor, 1)
	#draw_circle(Vector2(0, -$BodyShape.shape.height), $Visibility/VisibilyShape.shape.radius, color)
	#if recent_tar != null:
		#draw_line(Vector2(0, -$BodyShape.shape.height), recent_tar.global_position - position, lazerColor)
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
	if recent_tar == area:
		recent_tar = null


func _on_CatchArea_body_entered(body):
	if body.get_name() == 'Player':
		player_target = body

func _on_CatchArea_body_exited(body):
	if body == player_target:
		player_target = null

func _on_CatchArea_area_entered(area):
	if area.has_method("activate"):
		torch_area = area

func _on_CatchArea_area_exited(area):
	if area == torch_area:
		torch_area = null

func check_chase():
	var space_state = get_world_2d().direct_space_state
	var current
	var i = 0
	while (i < targets.size()):
		current = targets[i]
		update()
		target_dir = current.global_position - position - vision_center
		var res = space_state.intersect_ray(global_position + vision_center, current.global_position, [self], collision_mask, true, true)
		if not res and target_dir.x * direction > 0:
			mode = CHASING
			recent_tar = current
			return
		i += 1 
	if i == targets.size():
		mode = ROAMING
		recent_tar = null
		if direction == 0:
			direction = ex_direction


func _on_JumpTimer_timeout():
	can_jump = true
