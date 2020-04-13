extends Node2D

var turnOn=false
var numPlay=0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$MusicGame1.stop()
	$MusicGame2.stop()
	$MusicGame3.stop()
	turnOn=false


func playMusic(on):
	turnOn=on


func play(num):
	while(num==numPlay):
		num=randi()%3
	if(num==1):
		$MusicGame1.play()
		numPlay=1
	if(num==2):
		$MusicGame2.play()
		numPlay=2
	if(num==3):
		$MusicGame3.play()
		numPlay=3


func _process(delta):
	if(turnOn):
		if(!$MusicGame1.is_playing()&&!$MusicGame2.is_playing()&&!$MusicGame3.is_playing()):
			play(randi()%3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
