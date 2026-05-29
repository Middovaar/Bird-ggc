extends Area2D

var GarbagePileOne:Vector2
var GarbagePileTwo:Vector2
var GarbagePileThree:Vector2
var GarbagePileFour:Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	GarbagePileOne = $Garbage1.position
	GarbagePileTwo = $Garbage2.position
	GarbagePileThree = $Garbage3.position
	GarbagePileFour = $Garbage4.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
