extends KinematicBody2D

class_name Player


const WEAPONS_NUM = 1
const GRAVITY_VEC = Vector2(0,1100)
const FLOOR_NORMAL = Vector2(0, -1)
export (int) var WALK_SPEED = 225 # pixels/sec
export (int) var JUMP_SPEED = 280
export (float) var INERTIA = 0.8
export (int) var JUMP_HEIGHT_LIMIT = 65

export (float) var SCALE_X = 1.3
export (float) var SCALE_Y = 1.3

var linear_vel = Vector2()

var weapons=[]  
var on_player_area_node
var in_node_area = false



var height = 0
var jumping=false
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
	

func prepare_camera(var LU, var RD):
	$Camera.limit_left = LU.x
	$Camera.limit_top = LU.y
	$Camera.limit_right = RD.x
	$Camera.limit_bottom = RD.y


func _process(delta):
	if Input.is_action_just_pressed("ui_interact") and in_node_area:
		on_player_area_node.activate()
	
	control_weapons()




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
	
	if Input.is_action_pressed("ui_right"):
		target_speed += 1
		if not Input.is_action_pressed("ui_left"):
			sprite.scale.x = SCALE_X
		

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




func _on_IgnisRegularOuter_ignis_regular_taken():
	if $Informator.is_ignis:
		turn_off_ignis()
	
	var node = preload("res://IgnisRegularInner/IgnisRegularInner.tscn").instance()
	weapons[0] = node
	$Informator.has_weapons[0] = true
	turn_on_ignis(0)
	
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
	if Input.is_action_just_pressed("ui_1") and $Informator.has_weapons[0]:
		if $Informator.num_of_active_weapon == 0:
			turn_off_ignis()
			switch_sprites($iconWithoutIgnis, $iconWithIgnis)
		else:
			if $Informator.is_ignis:
				turn_off_ignis()
			turn_on_ignis(0)
			switch_sprites($iconWithIgnis, $iconWithoutIgnis)


func turn_off_ignis():
	remove_child(weapons[$Informator.num_of_active_weapon])
	$Informator.is_ignis = false
	$Informator.num_of_active_weapon = -1

func turn_on_ignis(num):
	add_child(weapons[num])
	$Informator.is_ignis=true
	$Informator.num_of_active_weapon = num
