extends Sprite2D

var executeSpin:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if executeSpin:
		rotation_degrees += 2

func _on_button_mouse_entered():
	visible = true


func _on_button_mouse_exited():
	visible = false
	executeSpin = false
	rotation = 0

func _on_button_pressed():
	executeSpin = true
	await get_tree().create_timer(0.6).timeout
	executeSpin = false
