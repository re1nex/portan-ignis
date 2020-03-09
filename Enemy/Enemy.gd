extends KinematicBody2D

class_name Enemy 

signal catch

var color = Color(.867, .91, .247, 0.1)
var lazerColor = Color(0.411765, 0.015686, 0.015686, 0.101961)
const GRAVITY_VEC = Vector2(0, 1500)
export (int) var walk_speed = 100
export (int) var run_speed = 250
var direction = 1
var velocity = Vector2()
const ROAMING = 0
const CHASING = 1 
var mode = ROAMING
var target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	if target:
		check_chase()
	else:
		mode = ROAMING
	velocity += GRAVITY_VEC * delta
	if mode == ROAMING:
		velocity.x = direction * walk_speed
		if not $RayDownLeft.is_colliding() or $RayLeft.is_colliding():
		#if $RayLeft.is_colliding():
			direction = 1.0
		if not $RayDownRight.is_colliding() or $RayRight.is_colliding():
		#if $RayRight.is_colliding():
			direction = -1.0
	else:
		var target_dir = target.global_position - position
		if abs(target_dir.x) < 5:
			direction = 0
		else:
			if target_dir.x > 0:
				direction = 1
			elif target_dir.x < 0:
				direction = -1
			else:
				direction = 0
		velocity.x = direction * run_speed
	velocity = move_and_slide(velocity)


func _on_Visibility_area_entered(area):
		target = area


func _on_Visibility_area_exited(area):
	if target == area:
		mode = ROAMING
		target = null
		direction = 1.0
	


func _on_CatchArea_body_entered(body):
	emit_signal("catch") 

func check_chase():
	var space_state = get_world_2d().direct_space_state
	var res = space_state.intersect_ray(position, target.global_position, [self, get_parent().get_parent().get_node("Player")], collision_mask)
	#var name = res.collider.name
	if not res:
		mode = CHASING
	else:
		mode = ROAMING

