extends CharacterBody2D


const MovmentSpeed = 300.0
const JumpVelocity = -600.0


func _physics_process(delta):
	## Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	## Jump when on floor
	if Input.is_action_just_pressed("Jump"):
		velocity.y = JumpVelocity

	# Essentially an A/B selector which outputs -> -1, +1.
	var direction = Input.get_axis("Left", "Right")
	# Depending on polarity, move char in that direction
	if direction:
		velocity.x = direction * MovmentSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, MovmentSpeed)
	move_and_slide()
