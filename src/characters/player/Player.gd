extends KinematicBody2D

signal die
signal health_changed
signal torch_changed
signal torch_reloaded
signal torch_hidden

class_name Player

enum Ignis_type {
		REGULAR,
		SECTOR,
}

enum Instruments_type {
		LEVER,
}

const SMALL_TWITCHING = 5
const WEAPONS_NUM = 2
const GRAVITY = 550
const FLOOR_NORMAL = Vector2(0, -1)
export (int) var walk_speed = 115 # pixels/sec
export (int) var jump_speed = 130
export (float) var inertia = 1
export (int) var jump_height_limit = 32

export (float) var scale_x = 1
export (float) var scale_y = 1

export (float) var recharge_coef = 1.5
export (float) var life_time_of_ignis = 3
export (float) var hit_time = 1

export (float) var dead_zone = 0.2

export (float) var landing_time = 0.15

export (int) var health = 5

var linear_vel = Vector2()
var velocity = Vector2()
var gravity_vec = Vector2()


var instruments = []
var weapons = []  
var on_player_area_node
var in_node_area = false
var ignis_pos = Vector2(0, 0)

var height = 0
var jumping = false
var direction = 1 # -1 - left; 1 - right
var ignis_direction = 1 # -1 - left; 1 - right
var sprite

var on_stairs = 0


var changeIgnis = false
# Called when the node enters the scene tree for the first time.
func _ready():
	
	scale.x=scale_x
	scale.y=scale_y
	
	weapons.resize(WEAPONS_NUM)
	
	ignis_pos = $IgnisPosition.get_position()
	fill_weapons()
	
	sprite = $AnimatedSprite1
	sprite.animation = "walk"
	
	gravity_vec.y = GRAVITY
	
	$TimerIgnis.connect("timeout", self, "_on_Timer_timeout")
	


func prepare_camera(var LU, var RD):
	$Camera.limit_left = LU.x
	$Camera.limit_top = LU.y
	$Camera.limit_right = RD.x
	$Camera.limit_bottom = RD.y


func _process(delta):
	if Input.is_action_just_pressed("ui_interaction") and in_node_area:
		on_player_area_node.activate()
	
	if Input.is_action_just_pressed("ui_recharge") and in_node_area and "activated" in on_player_area_node:
		recharge()
	
	control_weapons()
	
	update_ignis_timer_start(delta)
	
	check_rotate_ignis(delta)
	


func _physics_process(delta):
	### MOVEMENT ###
	# Apply gravity
	linear_vel += delta * gravity_vec
	# Move and slide
	changeIgnis = false
	var snap =  Vector2.DOWN * 15 if !jumping else Vector2.ZERO
	
	linear_vel = move_and_slide_with_snap(linear_vel, snap, FLOOR_NORMAL)

	# Detect if we are on floor - only works if called *after* move_and_slide
	var on_floor = is_on_floor()
	
	if on_floor:
		height=0
	### CONTROL ###

	# Horizontal movement
	var target_speed = 0
	if Input.is_action_pressed("ui_left"):
		target_speed -= 1
		if(!$AudioStep.playing &&on_floor):$AudioStep.play()
		if not Input.is_action_pressed("ui_right") and direction == 1:
			direction = -1
			sprite.flip_h = true
			$CharacterShape.scale.x *= -1
			if $Informator.num_of_active_weapon != -1:
				update_ignis()

	
	if Input.is_action_pressed("ui_right"):
		target_speed += 1
		if(!$AudioStep.playing&&on_floor):$AudioStep.play()
		if not Input.is_action_pressed("ui_left") and direction == -1:
			direction = 1
			sprite.flip_h = false
			$CharacterShape.scale.x *= -1
			if $Informator.num_of_active_weapon != -1:
				update_ignis()
	
	target_speed *= walk_speed
	linear_vel.x = lerp(linear_vel.x, target_speed, inertia)
	
	
	
	if on_floor:
		if sprite.animation == "fall":
			sprite.animation = "landing"
			$TimerLanding.set_wait_time(landing_time)
			$TimerLanding.start()
		if $TimerLanding.is_stopped():
			if abs(linear_vel.x) > SMALL_TWITCHING:
				sprite.animation = "walk"
			else:
				sprite.animation = "stay"
	else:
		if linear_vel.y < 0:
			sprite.animation = "jump"
			pass
		elif linear_vel.y > 0:
			sprite.animation = "fall"
			
	
	# Jumping
	#if is_on_ceiling():
		#linear_vel.y = 0
		#jumping = false
	if on_stairs > 0:
		linear_vel.y = 0
		if Input.is_action_pressed("ui_up"):
			position.y -= walk_speed * delta
			sprite.animation = "jump"
			sprite.set_frame(1)
		elif Input.is_action_pressed("ui_down"):
			position.y += walk_speed * delta
			sprite.animation = "fall"
		else:
			sprite.animation = "stay"
		
	else:
		if on_floor and Input.is_action_pressed("jump"):
			linear_vel.y = -jump_speed
			height -= linear_vel.y * delta
			jumping = true
			sprite.animation = "jump"
		
		elif jumping==true:
			if Input.is_action_pressed("jump") and height < jump_height_limit:
				linear_vel.y = -jump_speed
				height -= linear_vel.y * delta
			else:
				jumping=false


func _on_Area2D_area_entered(area):
	if area.has_method("activate"):
		on_player_area_node = area;
		in_node_area = true
	elif area.get_class() == "Stairs":
		jumping = true
		if on_stairs == 0:
			linear_vel.y = 0
			gravity_vec.y = 0
		on_stairs += 1
		print("+")
	pass # Replace with function body.


func _on_Area2D_area_exited(area):
	if on_player_area_node == area:
		in_node_area = false
	elif area.get_class() == "Stairs":
		on_stairs -= 1
		if on_stairs == 0:
			gravity_vec.y = GRAVITY
		print("-")
	pass # Replace with function body.


func _on_IgnisRegularOuter_ignis_regular_taken(type):
	if $Informator.ignis_status == $Informator.Is_ignis.HAS_IGNIS:
		turn_off_ignis()
	
	if type == Ignis_type.REGULAR :
		$Informator.has_weapons[Ignis_type.REGULAR] = true
		#turn_on_ignis(Ignis_type.REGULAR)
		#switch_sprites($iconWithIgnis)
	
	if type == Ignis_type.REGULAR:
		$Informator.has_weapons[Ignis_type.SECTOR] = true
		turn_on_ignis(Ignis_type.SECTOR)
		#switch_sprites($iconWithIgnis)
	pass # Replace with function body.

func get_informator():
	return $Informator


func synchronize_sprites(opp1, opp2):
	if opp1.scale.x * opp2.scale.x < 0:
		opp1.scale.x *= -1

func switch_sprites(new_sprite):
	sprite.hide()
	new_sprite.hide()
	synchronize_sprites(new_sprite, sprite)
	sprite = new_sprite

func control_weapons():
	if $Informator.ignis_status == $Informator.Is_ignis.HAS_IGNIS:
		
		if Input.is_action_just_released("ui_weapon_up"):
			var type = $Informator.num_of_active_weapon + 1
			if type >= WEAPONS_NUM:
				type = 0
			while not $Informator.has_weapons[type]:
				type+=1
				if type >= WEAPONS_NUM:
					type = 0
			switch_weapons(type)
		
		elif Input.is_action_just_released("ui_weapon_down"):
			var type = $Informator.num_of_active_weapon - 1
			if type < 0:
				type = WEAPONS_NUM -1
			while not $Informator.has_weapons[type]:
				type-=1
				if type < 0:
					type = WEAPONS_NUM -1
			switch_weapons(type)
	
	if not $Informator.ignis_status == $Informator.Is_ignis.NO_IGNIS:
		if Input.is_action_just_pressed("switch_ignis"):
			if $Informator.ignis_status == $Informator.Is_ignis.HAS_IGNIS:
				turn_off_ignis()
			else:
				turn_on_ignis($Informator.num_of_active_weapon)
		
		if Input.is_action_just_pressed("ui_1") and $Informator.has_weapons[Ignis_type.REGULAR]:
			switch_weapons(Ignis_type.REGULAR)
		
		if Input.is_action_just_pressed("ui_2") and $Informator.has_weapons[Ignis_type.SECTOR]:
			switch_weapons(Ignis_type.SECTOR)


func turn_off_ignis():
	weapons[$Informator.num_of_active_weapon].disable()
	$Informator.ignis_status = $Informator.Is_ignis.HIDE_IGNIS
	#$Informator.num_of_active_weapon = -1
	if(!changeIgnis):
		$AudioIngisLoop.stop()
		$AudioIngisOff.play()
	turn_on_ignis_timer()
	emit_signal("torch_hidden")

func turn_on_ignis(num):
	if $Informator.ignis_status == $Informator.Is_ignis.HIDE_IGNIS:
		turn_off_ignis_time()
	$Informator.ignis_status = $Informator.Is_ignis.HAS_IGNIS
	$Informator.num_of_active_weapon = num
	if(!changeIgnis):
		$AudioIngisOff.stop()
		$AudioIngisLoop.play()
	update_ignis()
	weapons[num].enable()
	emit_signal("torch_changed")

func turn_on_ignis_timer():
	$TimerIgnis.set_wait_time($Informator.ignis_timer_start)
	$TimerIgnis.start()

func turn_off_ignis_time():
	$TimerIgnis.stop()

func _on_Timer_timeout():
	$Informator.ignis_status = $Informator.Is_ignis.NO_IGNIS


func fill_weapons():
	var node = preload("res://src/objects/IgnisRegularInner/IgnisRegularInner.tscn").instance()
	node.priority = 2
	weapons[Ignis_type.REGULAR] = node
	add_child(weapons[Ignis_type.REGULAR])
	weapons[Ignis_type.REGULAR].disable()
	
	node = preload("res://src/objects/IgnisSectorInner/IgnisSectorInner.tscn").instance()
	weapons[Ignis_type.SECTOR] = node
	add_child(weapons[Ignis_type.SECTOR])
	weapons[Ignis_type.SECTOR].disable()
	
	for i in range(WEAPONS_NUM):
		weapons[i].scale.x/=scale_x
		weapons[i].scale.y/=scale_y


func fill_instruments():
	var node = preload("res://src/objects/lever/Lever.tscn").instance()
	instruments[Instruments_type.LEVER] = node

func update_ignis_timer_start(delta):
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
				#switch_sprites($iconWithIgnis)
	emit_signal("torch_reloaded")


func check_rotate_ignis(delta):
	if $Informator.num_of_active_weapon != -1:
		if Input.get_connected_joypads().size() > 0:
			var x_ax = -Input.get_joy_axis(0, JOY_ANALOG_RY)
			var y_ax = Input.get_joy_axis(0, JOY_ANALOG_RX)
			if abs(x_ax) > dead_zone or abs(y_ax) > dead_zone:
				var angle = atan2(y_ax, x_ax)
				if angle > 0:
					if not Input.is_action_pressed("ui_left"):
						if direction == -1:
							direction = 1
							sprite.flip_h = false
							update_ignis()
						var angle_delta = angle - weapons[$Informator.num_of_active_weapon].rotation
						weapons[$Informator.num_of_active_weapon].rotate_ignis(angle_delta)
				else:
					if not Input.is_action_pressed("ui_right"):
						if direction == 1:
							direction = -1
							sprite.flip_h = true
							update_ignis()
						var angle_delta = weapons[$Informator.num_of_active_weapon].rotation - angle
						weapons[$Informator.num_of_active_weapon].rotate_ignis(angle_delta)

		if Input.is_action_pressed("ui_rotate_down"):
			weapons[$Informator.num_of_active_weapon].rotate_ignis(PI / 2 * delta)
		if Input.is_action_pressed("ui_rotate_up"):
			weapons[$Informator.num_of_active_weapon].rotate_ignis(- PI / 2 * delta)

func update_ignis():
	ignis_pos.x = direction * $IgnisPosition.position.x

	for i in range(WEAPONS_NUM):
		weapons[i].set_position(ignis_pos)
		if weapons[i].reflected != direction:
			weapons[i].mirror()
	
	ignis_direction = direction
	pass

func turn_on_hit_timer():
	$TimerHit.set_wait_time(hit_time)
	$TimerHit.start()
	
func hit():
	if $TimerHit.is_stopped():
		$Informator.health -= 1
		emit_signal("health_changed")
		if $Informator.health == 0:
			emit_signal("die")
			
		if $Informator.ignis_status==$Informator.Is_ignis.HAS_IGNIS:
			$Informator.ignis_timer_start-= life_time_of_ignis / 4
		turn_on_hit_timer()
	pass

func switch_weapons(type):
	if $Informator.ignis_status == $Informator.Is_ignis.HAS_IGNIS and $Informator.num_of_active_weapon == type:
		pass
	else:
		if $Informator.ignis_status == $Informator.Is_ignis.HAS_IGNIS:
			changeIgnis=true
			turn_off_ignis()
		turn_on_ignis(type)
		emit_signal("torch_changed")


func _on_Lever_lever_taken():
	$Informator.has_instruments[Instruments_type.LEVER] = true
	pass # Replace with function body.


func take_heart():
	if $Informator.health < 5:
		$Informator.health += 1
		emit_signal("health_changed")
		return true # heart taken --> can free heart
	return false # heart not taken --> can't free heart


func highway_to_hell(delta):
	linear_vel.x = lerp(linear_vel.x, walk_speed, 1)
	move_and_slide(linear_vel)
