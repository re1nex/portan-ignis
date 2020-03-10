extends KinematicBody2D

class_name Player

enum Ignis_type {
		REGULAR,
		SECTOR,
}

const WEAPONS_NUM = 1
const GRAVITY_VEC = Vector2(0,1100)
const FLOOR_NORMAL = Vector2(0, -1)
export (int) var WALK_SPEED = 225 # pixels/sec
export (int) var JUMP_SPEED = 280
export (float) var INERTIA = 0.8
export (int) var JUMP_HEIGHT_LIMIT = 65

export (float) var SCALE_X = 1.3
export (float) var SCALE_Y = 1.3

export (float) var recharge_coef = 1.5
export (float) var LIFE_TIME_OF_IGNIS = 3

var linear_vel = Vector2()

var weapons=[]  
var on_player_area_node
var in_node_area = false
var ignis_pos = Vector2(0, 0)

var height = 0
var jumping = false
onready var sprite = $iconWithoutIgnis


# Called when the node enters the scene tree for the first time.
func _ready():
	$iconWithIgnis.scale.x=SCALE_X
	$iconWithIgnis.scale.y=SCALE_Y
	
	$iconWithoutIgnis.scale.x=SCALE_X
	$iconWithoutIgnis.scale.y=SCALE_Y
	
	$Area/CollisionShape.scale.x=SCALE_X
	$Area/CollisionShape.scale.y=SCALE_Y
	
	$CollisionShape.scale.x=SCALE_X
	$CollisionShape.scale.y=SCALE_Y
	
	$iconWithIgnis.hide()
	$iconWithoutIgnis.show()
	sprite = $iconWithoutIgnis
	weapons.resize(WEAPONS_NUM)
	
	ignis_pos = $IgnisPosition.get_position()
	fill_weapons()
	
	$Timer.connect("timeout",self, "_on_Timer_timeout")
	

func prepare_camera(var LU, var RD):
	$Camera.limit_left = LU.x
	$Camera.limit_top = LU.y
	$Camera.limit_right = RD.x
	$Camera.limit_bottom = RD.y


func _process(delta):
	if Input.is_action_just_pressed("ui_interact") and in_node_area:
		on_player_area_node.activate()
	
	if Input.is_action_just_pressed("ui_R") and in_node_area and "activated" in on_player_area_node:
		recharge()
	
	control_weapons()
	
	update_timer_start(delta)




func _physics_process(delta):
	### MOVEMENT ###
	# Apply gravity
	linear_vel += delta * GRAVITY_VEC
	# Move and slide
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL)
	# Detect if we are on floor - only works if called *after* move_and_slide
	var on_floor = is_on_floor()
	
	if on_floor:
		height=0
	### CONTROL ###
	
	# Horizontal movement
	var target_speed = 0
	if Input.is_action_pressed("ui_left"):
		target_speed -= 1
		if not Input.is_action_pressed("ui_right"):
			sprite.scale.x = -SCALE_X
			ignis_pos.x = - $IgnisPosition.position.x
			weapons[$Informator.num_of_active_weapon].set_position(ignis_pos)
	
	if Input.is_action_pressed("ui_right"):
		target_speed += 1
		if not Input.is_action_pressed("ui_left"):
			sprite.scale.x = SCALE_X
			ignis_pos.x = $IgnisPosition.position.x
			weapons[$Informator.num_of_active_weapon].set_position(ignis_pos)
			
	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, INERTIA)
	
	# Jumping
	if on_floor and Input.is_action_pressed("ui_up"):
		linear_vel.y = -JUMP_SPEED
		height -= linear_vel.y * delta
		jumping=true
	
	elif jumping==true:
		if Input.is_action_pressed("ui_up") and height < JUMP_HEIGHT_LIMIT:
			linear_vel.y = -JUMP_SPEED
			height -= linear_vel.y * delta
		else:
			jumping=false



func _on_Area2D_area_entered(area):
	if area.has_method("activate"):
		on_player_area_node = area;
		in_node_area=true
	pass # Replace with function body.


func _on_Area2D_area_exited(area):
	if on_player_area_node == area:
		in_node_area = false
	pass # Replace with function body.




func _on_IgnisRegularOuter_ignis_regular_taken(type):
	if $Informator.ignis_status == $Informator.Is_ignis.HAS_IGNIS:
		turn_off_ignis()
	
	if(type == Ignis_type.REGULAR):
		$Informator.has_weapons[Ignis_type.REGULAR] = true
		turn_on_ignis(Ignis_type.REGULAR)
		switch_sprites($iconWithIgnis, $iconWithoutIgnis)
	
	pass # Replace with function body.

func get_informator():
	return $Informator


func synchronize_sprites(opp1, opp2):
	if opp1.scale.x * opp2.scale.x < 0:
		opp1.scale.x *= -1

func switch_sprites(new_sprite, old_sprite):
	old_sprite.hide()
	new_sprite.show()
	synchronize_sprites(new_sprite, old_sprite)
	sprite = new_sprite


func control_weapons():
	if not $Informator.ignis_status == $Informator.Is_ignis.NO_IGNIS:
		if Input.is_action_just_pressed("ui_1") and $Informator.has_weapons[0]:
			if $Informator.num_of_active_weapon == 0:
				turn_off_ignis()
				switch_sprites($iconWithoutIgnis, $iconWithIgnis)
			else:
				if $Informator.ignis_status == $Informator.Is_ignis.HAS_IGNIS:
					turn_off_ignis()
				turn_on_ignis(Ignis_type.REGULAR)
				switch_sprites($iconWithIgnis, $iconWithoutIgnis)


func turn_off_ignis():
	weapons[$Informator.num_of_active_weapon].disable()
	$Informator.ignis_status = $Informator.Is_ignis.HIDE_IGNIS
	$Informator.num_of_active_weapon = -1
	turn_on_timer(LIFE_TIME_OF_IGNIS)

func turn_on_ignis(num):
	if $Informator.ignis_status == $Informator.Is_ignis.HIDE_IGNIS:
		turn_off_timer()
	$Informator.ignis_status = $Informator.Is_ignis.HAS_IGNIS
	$Informator.num_of_active_weapon = num
	weapons[num].set_position(ignis_pos)
	weapons[num].enable()

func turn_on_timer(time):
	$Timer.set_wait_time($Informator.timer_start)
	$Timer.start()

func turn_off_timer():
	$Timer.stop()

func _on_Timer_timeout():
	for i in range(WEAPONS_NUM):
		$Informator.ignis_status = $Informator.Is_ignis.NO_IGNIS


func fill_weapons():
	var node = preload("res://IgnisRegularInner/IgnisRegularInner.tscn").instance()
	weapons[Ignis_type.REGULAR] = node
	add_child(weapons[Ignis_type.REGULAR])
	weapons[Ignis_type.REGULAR].disable()



func update_timer_start(delta):
	if $Timer.is_stopped():
		if $Informator.timer_start < LIFE_TIME_OF_IGNIS:
			$Informator.timer_start += delta * recharge_coef
		elif $Informator.timer_start > LIFE_TIME_OF_IGNIS:
			$Informator.timer_start = LIFE_TIME_OF_IGNIS
	else:
		$Informator.timer_start = $Timer.time_left


func recharge():
	if on_player_area_node.activated and $Informator.ignis_status != $Informator.Is_ignis.HAS_IGNIS:
			if not $Timer.is_stopped():
				turn_off_timer()
			$Informator.timer_start = LIFE_TIME_OF_IGNIS
			$Informator.ignis_status = $Informator.Is_ignis.HAS_IGNIS
			if $Informator.has_weapons[Ignis_type.REGULAR]:
				turn_on_ignis(Ignis_type.REGULAR)
				switch_sprites($iconWithIgnis, $iconWithoutIgnis)
