extends KinematicBody2D

class_name Enemy 

signal catch

var color = Color(.867, .91, .247, 0.1)
var lazerColor = Color(0.411765, 0.015686, 0.015686, 0.101961)
const GRAVITY_VEC = Vector2(0, 1500)
export (int) var walk_speed = 100
export (int) var run_speed = 250
export (int) var jump_speed = 280
var direction = 1
var velocity = Vector2()
const ROAMING = 0
const CHASING = 1 
const SMALL_RADIUS = 5
var mode = ROAMING
var targets = []
var recent_tar = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	#if targets:
	check_chase()
	
	##  Moving logic  ##
	velocity += GRAVITY_VEC * delta
	if mode == ROAMING:
		velocity.x = direction * walk_speed
		if not $RayDownLeft.is_colliding() or $RayLeft.is_colliding():
			direction = 1.0
		if not $RayDownRight.is_colliding() or $RayRight.is_colliding():
			direction = -1.0
	else:
		var target_dir = recent_tar.global_position - position
		if abs(target_dir.x) < SMALL_RADIUS:
			direction = 0
		else:
			if target_dir.x > 0:
				direction = 1
			elif target_dir.x < 0:
				direction = -1
			else:
				direction = 0
			#direction = 0
		velocity.x = direction * run_speed
	velocity = move_and_slide(velocity)

func _draw():
	draw_circle(Vector2(), $Visibility/VisibilyShape.shape.radius, color)

func _on_Visibility_area_entered(area):
	if area.get_parent().priority == 1:
		targets.push_back(area)
	else:
		targets.push_front(area)


func _on_Visibility_area_exited(area):
	if targets.bsearch(recent_tar) == targets.bsearch(area):
		targets.erase(area)
		check_chase()
	targets.erase(area)
	if recent_tar == area:
		recent_tar = null


func _on_CatchArea_body_entered(body):
	emit_signal("catch") 


func check_chase():
	var space_state = get_world_2d().direct_space_state
	#recent_tar = targets.front()
	var current
	var i = 0
	while (i < targets.size()):
		current = targets[i]
		var gp = current.global_position
		var res = space_state.intersect_ray(position, current.global_position, 
				[self, get_parent().get_parent().get_node("Player"), current], collision_mask)
		#var name = res.collider.name
		if not res:
			mode = CHASING
			recent_tar = current
			return
		else:
			i += 1
	mode = ROAMING
	if direction == 0:
		direction = 1
