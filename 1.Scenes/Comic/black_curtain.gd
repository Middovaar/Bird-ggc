extends Node2D

var Active:bool = false
signal Done()


func _ready():
	Active = true
	await get_tree().create_timer(0.5).timeout
	emit_signal("Done")

func _process(_delta):
	if Active:
		%Coverlayer.position.y = lerpf(%Coverlayer.position.y, -1100.0, 0.15)
