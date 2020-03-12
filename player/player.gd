extends KinematicBody2D

signal die

class_name Player

enum Ignis_type {
		REGULAR,
		SECTOR,
}

const WEAPONS_NUM = 2
const GRAVITY_VEC = Vector2(0,1100)
const FLOOR_NORMAL = Vector2(0, -1)
export (int) var walk_speed = 225 # pixels/sec
export (int) var jump_speed = 280
export (float) var inertia = 0.8
export (int) var jump_height_limit = 65

export (float) var scale_x = 1.3
export (float) var scale_y = 1.3

export (float) var recharge_coef = 1.5
export (float) var life_time_of_ignis = 3

export (int) var lives = 5
export (int) var health = 5

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
	$iconWithIgnis.scale.x=scale_x
	$iconWithIgnis.scale.y=scale_y
	
	$iconWithoutIgnis.scale.x=scale_x
	$iconWithoutIgnis.scale.y=scale_y
	
	$Area/CollisionShape.scale.x=scale_x
	$Area/CollisionShape.scale.y=scale_y
	
	$CollisionShape.scale.x=scale_x
	$CollisionShape.scale.y=scale_y
	
	$iconWithIgnis.hide()
	$iconWithoutIgnis.show()
	sprite = $iconWithoutIgnis
	weapons.resize(WEAPONS_NUM)
	
	ignis_pos = $IgnisPosition.get_position()
	fill_weapons()
	
	$TimerIgnis.connect("timeout",self, "_on_Timer_timeout")


func prepare_camera(var LU, var RD):
	$Camera.limit_left = LU.x
	$Camera.limit_top = LU.y
	$Camera.limit_right = RD.x
	$Camera.limit_bottom = RD.y


func _process(delta):
	if $Informator.lives == 0:
		emit_signal("die")
	
	if Input.is_action_just_pressed("ui_interaction") and in_node_area:
		on_player_area_node.activate()
	
	if Input.is_action_just_pressed("ui_recharge") and in_node_area and "activated" in on_player_area_node:
		recharge()
	
	control_weapons()
	
	update_ignis_ignis_timer_start(delta)
	
	check_rotate_ignis(delta)




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
			sprite.scale.x = -scale_x
			ignis_pos.x = - $IgnisPosition.position.x
			if $Informator.num_of_active_weapon != -1:
				weapons[$Informator.num_of_active_weapon].set_position(ignis_pos)
				weapons[$Informator.num_of_active_weapon].mirror()
	
	if Input.is_action_pressed("ui_right"):
		target_speed += 1
		if not Input.is_action_pressed("ui_left"):
			sprite.scale.x = scale_x
			ignis_pos.x = $IgnisPosition.position.x
			if $Informator.num_of_active_weapon != -1:
				weapons[$Informator.num_of_active_weapon].set_position(ignis_pos)
				weapons[$Informator.num_of_active_weapon].mirror()
	
	target_speed *= walk_speed
	linear_vel.x = lerp(linear_vel.x, target_speed, inertia)
	
	# Jumping
	if on_floor and Input.is_action_pressed("ui_up"):
		linear_vel.y = -jump_speed
		height -= linear_vel.y * delta
		jumping=true
	
	elif jumping==true:
		if Input.is_action_pressed("ui_up") and height < jump_height_limit:
			linear_vel.y = -jump_speed
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
		if Input.is_action_just_pressed("ui_1") and $Informator.has_weapons[Ignis_type.REGULAR]:
			if $Informator.num_of_active_weapon == Ignis_type.REGULAR:
				turn_off_ignis()
				switch_sprites($iconWithoutIgnis, $iconWithIgnis)
			else:
				if $Informator.ignis_status == $Informator.Is_ignis.HAS_IGNIS:
					turn_off_ignis()
				turn_on_ignis(Ignis_type.REGULAR)
				switch_sprites($iconWithIgnis, $iconWithoutIgnis)
				
		
		if Input.is_action_just_pressed("ui_2") and $Informator.has_weapons[Ignis_type.SECTOR]:
			if $Informator.num_of_active_weapon == Ignis_type.SECTOR:
				turn_off_ignis()
				switch_sprites($iconWithoutIgnis, $iconWithIgnis)
			else:
				if $Informator.ignis_status == $Informator.Is_ignis.HAS_IGNIS:
					turn_off_ignis()
				turn_on_ignis(Ignis_type.SECTOR)
				switch_sprites($iconWithIgnis, $iconWithoutIgnis)


func turn_off_ignis():
	weapons[$Informator.num_of_active_weapon].disable()
	$Informator.ignis_status = $Informator.Is_ignis.HIDE_IGNIS
	$Informator.num_of_active_weapon = -1
	turn_on_ignis_timer()

func turn_on_ignis(num):
	if $Informator.ignis_status == $Informator.Is_ignis.HIDE_IGNIS:
		turn_off_ignis_time()
	$Informator.ignis_status = $Informator.Is_ignis.HAS_IGNIS
	$Informator.num_of_active_weapon = num
	weapons[num].set_position(ignis_pos)
	weapons[num].enable()

func turn_on_ignis_timer():
	$TimerIgnis.set_wait_time($Informator.ignis_timer_start)
	$TimerIgnis.start()

func turn_off_ignis_time():
	$TimerIgnis.stop()

func _on_Timer_timeout():
	$Informator.ignis_status = $Informator.Is_ignis.NO_IGNIS


func fill_weapons():
	var node = preload("res://IgnisRegularInner/IgnisRegularInner.tscn").instance()
	weapons[Ignis_type.REGULAR] = node
	add_child(weapons[Ignis_type.REGULAR])
	weapons[Ignis_type.REGULAR].disable()



func update_ignis_ignis_timer_start(delta):
	if $TimerIgnis.is_stopped():
		if $Informator.ignis_timer_start < life_time_of_ignis:
			$Informator.ignis_timer_start += delta * recharge_coef
		elif $Informator.ignis_timer_start > life_time_of_ignis:
			$Informator.ignis_timer_start = life_time_of_ignis
	else:
		$Informator.ignis_timer_start = $TimerIgnis.time_left


func recharge():
	if on_player_area_node.activated and $Informator.ignis_status != $Informator.Is_ignis.HAS_IGNIS:
			if not $TimerIgnis.is_stopped():
				turn_off_ignis_time()
			$Informator.ignis_timer_start = life_time_of_ignis
			$Informator.ignis_status = $Informator.Is_ignis.HAS_IGNIS
			if $Informator.has_weapons[Ignis_type.REGULAR]:
				turn_on_ignis(Ignis_type.REGULAR)
				switch_sprites($iconWithIgnis, $iconWithoutIgnis)


func check_rotate_ignis(delta):
	if $Informator.num_of_active_weapon != -1:
		if Input.is_action_pressed("ui_rotate_right"):
			weapons[$Informator.num_of_active_weapon].rotate_ignis(PI / 2 * delta)
		if Input.is_action_pressed("ui_rotate_left"):
			weapons[$Informator.num_of_active_weapon].rotate_ignis(- PI / 2 * delta)

func hit():
	pass
