extends Node2D
var num




func reset():
	num=0


func play():
	if(num==0):$Sound.play()
	num+=1




func stop():
	if(num==1):$Sound.stop()
	num-=1


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	num=0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
