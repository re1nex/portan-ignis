extends KinematicBody2D

class_name Player


const WEAPONS_NUM = 1
const GRAVITY_VEC = Vector2(0,1100)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const WALK_SPEED = 225 # pixels/sec
const JUMP_SPEED = 280
const SIDING_CHANGE_SPEED = 10
const INERTIA = 0.8
const JUMP_HEIGHT_LIMIT = 55
var linear_vel = Vector2()
var shoot_time = 99999 # time since last shot

var instruments=[]  
var on_player_area_node
var in_node_area = false



var height = 0
var jumping=false
onready var sprite = $iconWithIgnis


# Called when the node enters the scene tree for the first time.
func _ready():
	$iconWithIgnis.hide()
	$iconWithoutIgnis.show()
	instruments.resize(WEAPONS_NUM)
	pass # Replace with function body.




func _physics_process(delta):
	# Increment counters
	shoot_time += delta

	### MOVEMENT ###

	# Apply gravity
	linear_vel += delta * GRAVITY_VEC
	# Move and slide
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	# Detect if we are on floor - only works if called *after* move_and_slide
	var on_floor = is_on_floor()
	
	if on_floor:
		height=0
	### CONTROL ###

	# Horizontal movement
	var target_speed = 0
	if Input.is_action_pressed("ui_left"):
		target_speed -= 1
	if Input.is_action_pressed("ui_right"):
		target_speed += 1

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
	
	if on_floor:
		if linear_vel.x < -SIDING_CHANGE_SPEED:
			sprite.scale.x = -1


		if linear_vel.x > SIDING_CHANGE_SPEED:
			sprite.scale.x = 1

	else:
		# We want the character to immediately change facing side when the player
		# tries to change direction, during air control.
		# This allows for example the player to shoot quickly left then right.
		if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			sprite.scale.x = -1
		if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
			sprite.scale.x = 1
	
	
	
	if Input.is_action_just_pressed("ui_interact") and in_node_area:
		on_player_area_node.activate()
	
	if Input.is_action_just_pressed("ui_1"):
		if $Informator.is_ignis:
			remove_child(instruments.back())
			$Informator.is_ignis=false
			$iconWithIgnis.hide()
			$iconWithoutIgnis.show()
		elif instruments[0]:
			add_child(instruments.back())
			$Informator.is_ignis=true
			$iconWithoutIgnis.hide()
			$iconWithIgnis.show()


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
		remove_child(instruments[0])
	
	$Informator.is_ignis=true
	var node = preload("res://IgnisRegularInner/IgnisRegularInner.tscn").instance()
	instruments[0] = node
	add_child(node)
	$iconWithoutIgnis.hide()
	$iconWithIgnis.show()
	pass # Replace with function body.

func get_informator():
	return $Informator
