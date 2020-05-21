extends KinematicBody2D

signal die

signal torch_hit
signal health_changed
signal torch_changed
signal torch_reloaded
signal torch_hidden
signal got_hit

class_name Player



const SMALL_TWITCHING = 5
const WEAPONS_NUM = 3
const INSTRUMENTS_NUM = 1
const MAX_HEALTH = 5
const GRAVITY = 550
const FLOOR_NORMAL = Vector2(0, -1)
export (int) var walk_speed = 115 # pixels/sec
export (int) var jump_speed = 130
export (float) var inertia = 1
export (int) var jump_height_limit = 32

export (float) var scale_x = 1
export (float) var scale_y = 1

export (float) var recharge_coef = 1.5
export (float) var life_time_of_ignis = 1 # for each life of ignis
export (float) var hit_time = 1

export (float) var dead_zone = 0.2

export (float) var landing_time = 0.15

var health = Transfer.health

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
var floor_vel = Vector2()
var is_on_platform = true

var endLevel=false
var on_stairs = 0

var changeIgnis = false
var blockPlayer=false
# Called when the node enters the scene tree for the first time.

func new_lvl():
	endLevel=false
	blockPlayer=false

func _ready():
	scale.x=scale_x
	scale.y=scale_y
	
	weapons.resize(WEAPONS_NUM)
	instruments.resize(INSTRUMENTS_NUM)
	
	ignis_pos = $IgnisPosition.get_position()
	fill_weapons()
	
	sprite = $AnimatedSprite1
	sprite.animation = "walk"
	
	gravity_vec.y = GRAVITY
	
	$TimerIgnis.connect("timeout", self, "_on_Timer_timeout")
	

func HitPlay(num):
	if(num == 1):
		$Audio/Hit/AudioHit.play()
	elif(num ==2):
		$Audio/Hit/AudioHit2.play()
	elif(num ==3):
		$Audio/Hit/AudioHit3.play()
	elif(num ==4):
		$Audio/Hit/AudioHit4.play()
	elif(num ==5):
		$Audio/Hit/AudioHit5.play()

func jump_play(num):
	if(num == 0):
		$Audio/Jump/AudioJump0.play()
	elif(num ==1):
		$Audio/Jump/AudioJump1.play()
	elif(num ==2):
		$Audio/Jump/AudioJump2.play()
	elif(num ==3):
		$Audio/Jump/AudioJump3.play()
	elif(num ==4):
		$Audio/Jump/AudioJump4.play()




func prepare_camera(var LU, var RD):
	$Camera.limit_left = LU.x
	$Camera.limit_top = LU.y
	$Camera.limit_right = RD.x
	$Camera.limit_bottom = RD.y


func _process(delta):
	if(endLevel||blockPlayer):
		update_ignis_timer_start(delta)
		return
		
	if in_node_area:
		if Input.is_action_just_pressed("ui_interaction"):
			on_player_area_node.activate()
		elif Input.is_action_just_released("ui_interaction") and on_player_area_node.has_method("disactivate"):
			on_player_area_node.disactivate()
			
	
	if Input.is_action_just_pressed("ui_recharge") and in_node_area and "health" in on_player_area_node:
		recharge()
	
	control_weapons()
	
	update_ignis_timer_start(delta)
	
	check_rotate_ignis(delta)

func goAway():
	var i=0
	blockPlayer=true

func _physics_process(delta):
	if(endLevel):
		return
	### MOVEMENT ###
	# Apply gravity
	linear_vel += delta * gravity_vec
	
	# Move and slide
	changeIgnis = false
	var snap =  Vector2.DOWN * 15 if !jumping and on_stairs == 0 else Vector2.ZERO
	linear_vel = move_and_slide_with_snap(linear_vel, snap, FLOOR_NORMAL)
	
	var obj = null #get_slide_collision(0)
	if get_slide_count() != 0:
		obj = get_slide_collision(0)
		if obj and obj.collider.get_name() == "Platform":
			is_on_platform = true
		else:
			is_on_platform = false
	# Detect if we are on floor - only works if called *after* move_and_slide
	var on_floor = is_on_floor()
	if not is_on_platform:
		floor_vel = Vector2.ZERO
	if on_floor:
		height=0
	### CONTROL ###

	# Horizontal movement
	var target_speed = 0
	if Input.is_action_pressed("ui_left") and not blockPlayer:
		target_speed -= 1
		if not Input.is_action_pressed("ui_right") and direction == 1:
			direction = -1
			sprite.flip_h = true
			$CharacterShape.scale.x *= -1
			if $Informator.num_of_active_weapon != -1:
				update_ignis()
				
	
	if Input.is_action_pressed("ui_right") || blockPlayer:
		target_speed += 1
		if not Input.is_action_pressed("ui_left") and direction == -1 and not blockPlayer:
			direction = 1
			sprite.flip_h = false
			$CharacterShape.scale.x *= -1
			if $Informator.num_of_active_weapon != -1:
				update_ignis()
	
	target_speed *= walk_speed
	linear_vel.x = lerp(linear_vel.x, target_speed, inertia)
	
	# VERTICAL MOVEMENT
	
	# STAIRS
	if on_stairs > 0:
		var target_speed_y = 0
		if Input.is_action_pressed("ui_up") and not is_on_ceiling():
			target_speed_y = - walk_speed
			
		elif Input.is_action_pressed("ui_down") and not on_floor:
			target_speed_y = walk_speed
			
		
		linear_vel.y = lerp(linear_vel.y, target_speed_y, 1)
		
		if abs(linear_vel.y) > 0:
			sprite.animation = "stairsMove"
			if not $Audio/Move/AudioStairs.playing:
				$Audio/Move/AudioStairs.play()
		else:
			sprite.animation = "stairsStay"
			if $Audio/Move/AudioStairs.playing:
				$Audio/Move/AudioStairs.stop()
	
	# NOT STAIRS
	else:
		#ON FLOOR
		if on_floor:
			#LANDING
			if sprite.animation == "fall":
				sprite.animation = "landing"
				$Audio/Move/AudioLanding.play()
				
				$TimerLanding.set_wait_time(landing_time)
				$TimerLanding.start()
			#WALK AFTER LANDING
			elif $TimerLanding.is_stopped():
				if abs(linear_vel.x) > SMALL_TWITCHING:
					sprite.animation = "walk"
					if (sprite.get_frame() == 0 or sprite.get_frame() == 2) and not $Audio/Move/AudioStep.playing:
						$Audio/Move/AudioStep.play()
				
				else:
					sprite.animation = "stay"
			#JUMP
			if Input.is_action_pressed("jump") and not blockPlayer:
				if is_on_platform:
					floor_vel = get_floor_velocity()
				else:
					floor_vel = Vector2.ZERO
				linear_vel.y = -jump_speed
				height -= linear_vel.y * delta
				jumping = true
				sprite.animation = "jump"
				jump_play(randi()%5)
		
		#JUMPING
		else:
			if jumping==true and not blockPlayer:
				if Input.is_action_pressed("jump") and height < jump_height_limit:
					linear_vel.y = -jump_speed
					height -= linear_vel.y * delta
				else:
					jumping=false
					
			linear_vel.x += floor_vel.x
			if linear_vel.y < 0:
				sprite.animation = "jump"
				pass
			elif linear_vel.y > 0:
				sprite.animation = "fall"




func _on_Area2D_area_entered(area):
	if area.has_method("activate"):
		on_player_area_node = area;
		in_node_area = true
	elif area.get_class() == "Stairs":
		if on_stairs == 0:
			linear_vel.y = 0
			gravity_vec.y = 0
			floor_vel = Vector2.ZERO
			ignis_pos = $IgnisPositionOnStairs.get_position()
			update_ignis()
		on_stairs += 1
	pass # Replace with function body.


func _on_Area2D_area_exited(area):
	if on_player_area_node == area:
		if on_player_area_node.has_method("disactivate"):
			on_player_area_node.disactivate()
		in_node_area = false
	elif area.get_class() == "Stairs":
		on_stairs -= 1
		if on_stairs == 0:
			linear_vel.y = 0
			gravity_vec.y = GRAVITY
			if $Audio/Move/AudioStairs.playing:
				$Audio/Move/AudioStairs.stop()
			ignis_pos = $IgnisPosition.get_position()
			update_ignis()
	pass # Replace with function body.


func _on_IgnisRegularOuter_ignis_regular_taken(type):
	if $Informator.ignis_status == GlobalVars.Is_ignis.HAS_IGNIS:
		turn_off_ignis()
	
	if type == GlobalVars.Ignis_type.REGULAR :
		$Informator.has_weapons[GlobalVars.Ignis_type.REGULAR] = true
		turn_on_ignis(GlobalVars.Ignis_type.REGULAR)
		$Audio/Ignis/AudioIgnisOn.play()
		#switch_sprites($iconWithIgnis)
	
	if type == GlobalVars.Ignis_type.SECTOR:
		$Informator.has_weapons[GlobalVars.Ignis_type.SECTOR] = true
		turn_on_ignis(GlobalVars.Ignis_type.SECTOR)
		$Audio/Other/AudioPickUp.play()
		#switch_sprites($iconWithIgnis)
	
	if type == GlobalVars.Ignis_type.LONG_SECTOR:
		$Informator.has_weapons[GlobalVars.Ignis_type.LONG_SECTOR] = true
		turn_on_ignis(GlobalVars.Ignis_type.LONG_SECTOR)
		$Audio/Other/AudioPickUp.play()
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
	if $Informator.ignis_status == GlobalVars.Is_ignis.HAS_IGNIS:
		
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
	
	if not $Informator.ignis_status == GlobalVars.Is_ignis.NO_IGNIS:
		if Input.is_action_just_pressed("switch_ignis"):
			if $Informator.ignis_status == GlobalVars.Is_ignis.HAS_IGNIS:
				turn_off_ignis()
			else:
				turn_on_ignis($Informator.num_of_active_weapon)
		
		if Input.is_action_just_pressed("ui_1") and $Informator.has_weapons[GlobalVars.Ignis_type.REGULAR]:
			switch_weapons(GlobalVars.Ignis_type.REGULAR)
		
		if Input.is_action_just_pressed("ui_2") and $Informator.has_weapons[GlobalVars.Ignis_type.SECTOR]:
			switch_weapons(GlobalVars.Ignis_type.SECTOR)
		
		if Input.is_action_just_pressed("ui_3") and $Informator.has_weapons[GlobalVars.Ignis_type.LONG_SECTOR]:
			switch_weapons(GlobalVars.Ignis_type.LONG_SECTOR)


func turn_off_ignis():
	weapons[$Informator.num_of_active_weapon].disable()
	$Informator.ignis_status = GlobalVars.Is_ignis.HIDE_IGNIS
	#$Informator.num_of_active_weapon = -1
	if(!changeIgnis):
		$Audio/Ignis/AudioIngisLoop.stop()
		$Audio/Ignis/AudioIngisOff.play()
	turn_on_ignis_timer()
	emit_signal("torch_hidden")

func turn_on_ignis(num):
	if $Informator.ignis_status == GlobalVars.Is_ignis.HIDE_IGNIS:
		turn_off_ignis_time()
	$Informator.ignis_status = GlobalVars.Is_ignis.HAS_IGNIS
	$Informator.num_of_active_weapon = num
	if(!changeIgnis):
		$Audio/Ignis/AudioIngisOff.stop()
		$Audio/Ignis/AudioIngisLoop.play()
	update_ignis()
	weapons[num].reload($Informator.ignis_health)
	weapons[num].enable()
	emit_signal("torch_changed")

func turn_on_ignis_timer():
	$TimerIgnis.set_wait_time($Informator.ignis_timer_start)
	$TimerIgnis.start()

func turn_off_ignis_time():
	$TimerIgnis.stop()

func _on_Timer_timeout():
	if $Informator.ignis_health != GlobalVars.Ignis_state.OFF:
		$Informator.ignis_health -= 1
	if $Informator.ignis_health != GlobalVars.Ignis_state.OFF:
		$TimerIgnis.set_wait_time(life_time_of_ignis)
		$TimerIgnis.start()
	else:
		$Informator.ignis_status = GlobalVars.Is_ignis.NO_IGNIS


func fill_weapons():
	var node = preload("res://src/objects/IgnisRegularInner/IgnisRegularInner.tscn").instance()
	node.priority = 2
	node.finish_disabling()
	weapons[GlobalVars.Ignis_type.REGULAR] = node
	add_child(weapons[GlobalVars.Ignis_type.REGULAR])
	weapons[GlobalVars.Ignis_type.REGULAR].disable()
	
	node = preload("res://src/objects/IgnisSectorInner/IgnisSectorInner.tscn").instance()
	node.priority = 2
	weapons[GlobalVars.Ignis_type.SECTOR] = node
	add_child(weapons[GlobalVars.Ignis_type.SECTOR])
	weapons[GlobalVars.Ignis_type.SECTOR].disable()
	
	node = preload("res://src/objects/IgnisLongSectorInner/IgnisLongSectorInner.tscn").instance()
	node.priority = 2
	weapons[GlobalVars.Ignis_type.LONG_SECTOR] = node
	add_child(weapons[GlobalVars.Ignis_type.LONG_SECTOR])
	weapons[GlobalVars.Ignis_type.LONG_SECTOR].disable()
	
	if Transfer.cur_ignis_num != -1 and Transfer.cur_ignis_status != GlobalVars.Is_ignis.NO_IGNIS:
		turn_on_ignis(Transfer.cur_ignis_num)
	
	for i in range(WEAPONS_NUM):
		weapons[i].scale.x/=scale_x
		weapons[i].scale.y/=scale_y


func fill_instruments():
	for i in range(INSTRUMENTS_NUM):
		instruments[i] = Transfer.instruments[i]

func update_ignis_timer_start(delta):
	if $TimerIgnis.is_stopped():
		if $Informator.ignis_timer_start < life_time_of_ignis:
			$Informator.ignis_timer_start += delta * recharge_coef
		elif $Informator.ignis_timer_start > life_time_of_ignis:
			$Informator.ignis_timer_start = life_time_of_ignis
	else:
		$Informator.ignis_timer_start = $TimerIgnis.time_left


func recharge():
	if $Informator.ignis_health != on_player_area_node.health:
		if not $TimerIgnis.is_stopped():
			turn_off_ignis_time()
		$Informator.ignis_timer_start = life_time_of_ignis
		$Informator.ignis_status = GlobalVars.Is_ignis.HAS_IGNIS
		var max_health = max($Informator.ignis_health, on_player_area_node.health)
		if $Informator.ignis_health != max_health:
			$Informator.ignis_health = max_health
			turn_on_ignis($Informator.num_of_active_weapon)
			$Audio/Ignis/AudioIgnisOn.play()
		if on_player_area_node.health != max_health:
			on_player_area_node.reload(max_health)
		#if $Informator.has_weapons[GlobalVars.Ignis_type.REGULAR]:
			#turn_on_ignis(GlobalVars.Ignis_type.REGULAR)
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
			weapons[$Informator.num_of_active_weapon].rotate_ignis(PI * delta)
		if Input.is_action_pressed("ui_rotate_up"):
			weapons[$Informator.num_of_active_weapon].rotate_ignis(- PI * delta)

func update_ignis():
	if ignis_pos.x * direction < 0:
		ignis_pos.x *= -1

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
	if(endLevel):
		return
	if $TimerHit.is_stopped():
		HitPlay(randi()%5+1)
		$Informator.health -= 1
		emit_signal("health_changed")
		emit_signal("got_hit")
		if $Informator.health == 0:
			emit_signal("die")
			
		if $Informator.ignis_status==GlobalVars.Is_ignis.HAS_IGNIS:
			$Informator.ignis_timer_start-= life_time_of_ignis / 4
			$Informator.ignis_health = max(0, $Informator.ignis_health - 1)
			weapons[$Informator.num_of_active_weapon].hit()
			emit_signal("torch_hit")
		turn_on_hit_timer()
	pass

func switch_weapons(type):
	if $Informator.ignis_status == GlobalVars.Is_ignis.HAS_IGNIS and $Informator.num_of_active_weapon == type:
		pass
	else:
		if $Informator.ignis_status == GlobalVars.Is_ignis.HAS_IGNIS:
			changeIgnis=true
			turn_off_ignis()
		turn_on_ignis(type)
		$Audio/Ignis/AudioIgnisSwitch.play()
		emit_signal("torch_changed")


func _on_Lever_lever_taken():
	$Informator.has_instruments[GlobalVars.Instruments_type.LEVER] += 1
	$Audio/Other/AudioPickUp.play()
	pass # Replace with function body.

func after_die():
	endLevel=true
	visible=false
	turn_off_ignis()
	$Informator.health=0;



func take_heart():
	if $Informator.health < MAX_HEALTH:
		$Audio/Other/AudioPickUp.play()
		$Informator.health += 1
		emit_signal("health_changed")
		return true # heart taken --> can free heart
	return false # heart not taken --> can't free heart


func take_fuel():
	if $Informator.ignis_health < GlobalVars.Ignis_state.LIFE_MAX:
		$Audio/Other/AudioPickUp.play()
		$Informator.ignis_health += 1
		turn_on_ignis($Informator.num_of_active_weapon)
		emit_signal("torch_reloaded")
		return true # fuel taken --> can free fuel
	return false # fuel not taken --> can't free fuel


func highway_to_hell(delta):
	linear_vel.x = lerp(linear_vel.x, walk_speed, 1)
	move_and_slide(linear_vel)
