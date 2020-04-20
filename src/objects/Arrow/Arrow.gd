extends Area2D

export (int) var speed = 1000
var velocity = Vector2()

func start(pos, dir):
	$Shot.play()
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)

func _physics_process(delta):
	position += velocity * delta
	velocity += gravity * gravity_vec * delta
	rotation = velocity.angle()

func _on_Arrow_body_entered(body):
	$Shot.stop()
	if body.has_method('hit'):
		body.hit()
	queue_free()
	pass # Replace with function body.
