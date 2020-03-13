extends KinematicBody2D

class_name Enemy 

signal catch

var color = Color(.867, .91, .247, 0.1)
var lazerColor = Color(1, 0.007843, 0.007843, 0.1)
const GRAVITY_VEC = Vector2(0, 1500)
export (int) var walk_speed = 100
export (int) var run_speed = 250
export (int) var jump_speed = 150
var direction = 1
var velocity = Vector2()
const ROAMING = 0
const CHASING = 1 
const SMALL_RADIUS = 5
const JUMP_HEIGHT_LIMIT = 60
const JUMP_RADIUS = 120
const FLOOR_NORMAL = Vector2(0, -1)
var vision_center
var mode = ROAMING
var targets = []
var recent_tar = null
var torch_area = null
var height = 0
var jumping = false
var player_target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	vision_center = Vector2(0, -$BodyShape.shape.height)
	pass

func _physics_process(delta):
	if torch_area and "activated" in torch_area and torch_area.activated:
		torch_area.activate()
	check_chase()
	##  Moving logic  ##
	velocity += GRAVITY_VEC * delta
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	var on_floor = is_on_floor()
	if on_floor:
		height=0
	if mode == ROAMING:
		velocity.x = direction * walk_speed
		if not $RayDownLeft.is_colliding() or $RayLeft.is_colliding():
			direction = 1.0
		if not $RayDownRight.is_colliding() or $RayRight.is_colliding():
			direction = -1.0
	elif mode == CHASING:
		var target_dir = recent_tar.global_position - position - vision_center
		if abs(target_dir.x) < SMALL_RADIUS:
			direction = 0
		else:
			if target_dir.x > 0:
				direction = 1
			elif target_dir.x < 0:
				direction = -1
			else:
				direction = 0
		var tar_dir_rad = sqrt(target_dir.x * target_dir.x + target_dir.y * target_dir.y)
		if on_floor and target_dir.y < -SMALL_RADIUS and tar_dir_rad < JUMP_RADIUS:
			velocity.y = -jump_speed
			height -= velocity.y * delta
			jumping=true
		elif jumping==true:
			if height < JUMP_HEIGHT_LIMIT:
				velocity.y = -jump_speed
				height -= velocity.y * delta
			else:
				jumping=false
		velocity.x = direction * run_speed

func _draw():
	#pass
	#draw_circle(Vector2(0, -$BodyShape.shape.height), $Visibility/VisibilyShape.shape.radius, color)
	if recent_tar != null:
		draw_line(Vector2(0, -$BodyShape.shape.height), recent_tar.global_position - position, lazerColor)

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
	emit_signal("catch") 

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
		var res = space_state.intersect_ray(position + vision_center, current.global_position, [self], collision_mask)
		if not res:
			mode = CHASING
			recent_tar = current
			return
		i += 1 
	if i == targets.size():
		mode = ROAMING
		if direction == 0:
			direction = 1
