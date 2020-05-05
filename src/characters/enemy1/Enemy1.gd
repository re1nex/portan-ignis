extends KinematicBody2D

class_name Enemy1

var color = Color(.867, .91, .247, 0.1)
var lazerColor = Color(1, 0.007843, 0.007843, 0.9)
var greenColor = Color(0.015686, 0.996078, 0.215686)

enum GlanceEnum {LEFT = -1, RIGHT = 1}
enum Modes {STAYING = 0, ROAMING, CHASING}
export (GlanceEnum) var glance_dir = GlanceEnum.RIGHT
export (int, "walking", "staying") var start_mode = 0
export (int) var walk_speed = 100
export (int) var run_speed = 230
export (int) var jump_speed = 100
export (int) var jump_height_limit = 30
export (float) var landing_time = 0.2
export (bool) var falling_at_start = false

const SMALL_RADIUS = 5
const FLOOR_NORMAL = Vector2(0, -1)
const GRAVITY_VEC = Vector2(0, 550)

var direction: int = 1
var ex_direction: int
var velocity = Vector2()
var vision_center
var mode = Modes.ROAMING
var targets = []
var recent_tar = null
var target_dir
var torch_area = null
var player_target = null

var height = 0
var can_jump = true
var jumping = false
var v_scale

var sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	vision_center = $VisionPoint.position
	v_scale = $Visibility.scale.x
	sprite = $AnimatedSprite
	sprite.animation = "stay"
	jumping = falling_at_start
	direction = (start_mode ^ 1) * glance_dir
	if start_mode == 0:
		mode = Modes.ROAMING
	elif start_mode == 1:
		mode = Modes.STAYING
	pass


func _process(delta):
	if player_target:
		player_target.hit()
	elif torch_area: #and "health" in torch_area and torch_area.health != GlobalVars.Ignis_state.OFF:
		torch_area.hit()

func _physics_process(delta):
	
	check_chase()
	sprite.play()
	##  Moving logic  ##
	velocity += GRAVITY_VEC * delta
	velocity = move_and_slide(velocity, FLOOR_NORMAL, false, 4, 0.523598776)
	var on_floor = is_on_floor()
	if on_floor:
		height=0
		if (!$AudioStep.playing) : 
			$AudioStep.play()
	if (!$AudioVoice.playing) : 
		$AudioVoice.play()
	if mode == Modes.ROAMING:
		evaluate_roaming()
		if on_floor:
			jumping = false
	elif mode == Modes.CHASING:
		evaluate_chasing()
		# jumping while chasing #
		var tar_tg = target_dir.y / abs(target_dir.x)
		if on_floor and target_dir.y < -SMALL_RADIUS and tar_tg < -0.65 and can_jump:
			can_jump = false
			$JumpTimer.start()
			velocity.y = -jump_speed
			height -= velocity.y * delta
			jumping = true
		elif jumping == true:
			if height < jump_height_limit and target_dir.y < -SMALL_RADIUS:
				velocity.y = -jump_speed
				height -= velocity.y * delta
			else:
				jumping = false
		velocity.x = direction * run_speed
	flip_areas(glance_dir)
	
	if sprite.animation != "punch" && sprite.animation != "slash":
		if on_floor:
			if sprite.animation == "fall":
				sprite.animation = "landing"
				$TimerLanding.set_wait_time(landing_time)
				$TimerLanding.start()
			if $TimerLanding.is_stopped():
				if mode == Modes.STAYING:
					sprite.animation = "stay"
				else:
					sprite.animation = "walk"



func _draw():
#	if global_position:
#		draw_line(Vector2(0, 0), Vector2(20 * $Visibility.scale.x, 0), greenColor, 5)
#		if recent_tar != null:
#			draw_line(Vector2(0, 0), recent_tar.global_position - position, lazerColor, 10)
#		if targets:
#			for i in range(targets.size()):
#				draw_line(vision_center, targets[i].global_position - position, greenColor, 1)
	#draw_circle(Vector2(0, -10), 10 * $Visibility/VisibilyShape.scale.x, color)
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
		sprite.animation = "slash"
		player_target = body

func _on_CatchArea_body_exited(body):
	if body == player_target:
		sprite.animation = "walk"
		player_target = null

func _on_CatchArea_area_entered(area):
	if area.has_method("activate") and area.activated:
		sprite.animation = "punch"
		torch_area = area

func _on_CatchArea_area_exited(area):
	if area == torch_area:
		sprite.animation = "walk"
		torch_area = null

func _on_JumpTimer_timeout():
	can_jump = true

func flip_areas(dir):
	if dir == GlanceEnum.LEFT:
		sprite.flip_h = true
		$Visibility.scale.x = glance_dir * v_scale
		$CatchArea.scale.x = glance_dir * v_scale
	elif dir == GlanceEnum.RIGHT:
		sprite.flip_h = false
		$Visibility.scale.x = glance_dir * v_scale 
		$CatchArea.scale.x = glance_dir * v_scale 

func check_chase():
	var space_state = get_world_2d().direct_space_state
	var current
	var i = 0
	while (i < targets.size()):
		current = targets[i]
		target_dir = current.global_position - position - vision_center
		var res = space_state.intersect_ray(
			global_position + vision_center, 
			current.global_position, 
			[self], 
			#ProjectSettings.get_setting("layer_names/2d_physics/layer_3"), 
			1 << 2,
			true, 
			true)
		var ang = abs(target_dir.angle())
		if $CatchArea.scale.x < 0:
			ang = PI - ang
		if not res and ang <= 7 * PI / 12:
			mode = Modes.CHASING
			recent_tar = current
			return
		i += 1 
	if i == targets.size() and mode != Modes.STAYING:
		mode = Modes.ROAMING
		recent_tar = null
		if direction == 0:
			direction = ex_direction

func evaluate_roaming():
	velocity.x = direction * walk_speed
	if (not $RayDownLeft.is_colliding() and not jumping) or $RayLeft.is_colliding():
		direction = 1.0
		glance_dir = GlanceEnum.RIGHT
	if (not $RayDownRight.is_colliding() and not jumping) or $RayRight.is_colliding():
		direction = -1.0
		glance_dir = GlanceEnum.LEFT
	ex_direction = direction
	#if sprite.animation != "slash":
		#sprite.animation = "walk"

func evaluate_chasing():
	if abs(target_dir.x) < SMALL_RADIUS:
		#ex_direction = direction
		direction = 0
		#sprite.stop()
	else:
		sprite.speed_scale = 2
		if target_dir.x > 0:
			direction = 1
			ex_direction = direction
			glance_dir = GlanceEnum.RIGHT
		elif target_dir.x < 0:
			direction = -1
			ex_direction = direction
			glance_dir = GlanceEnum.LEFT
