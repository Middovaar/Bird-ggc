extends Camera2D





# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y = lerpf(position.y, %Player.position.y, 0.03)
	position.x = lerpf(position.x, %Player.position.x + %Player.velocity.x, 0.03)
	
	if %Player.AcceleratingDirection == Vector2(1,1) or %Player.AcceleratingDirection == Vector2(0,0) and %Player.IsDashing == 0:
		position = lerp(position, %Player.position, 0.03)
		zoom = lerp(zoom, Vector2(1.8, 1.8), 0.0018)
	else:
		if %Player.IsDashing == 1:
			zoom = lerp(zoom, Vector2(0.6, 0.6), 0.01)
		else:
			zoom = lerp(zoom, Vector2(1.0, 1.0), 0.06)
	
