extends AnimatedSprite2D

func _on_klo_animation(EmittingAnimation):
	match EmittingAnimation:
		"idle":
			play("idle")
		"walk":
			play("walking")
		"walking":
			play("walking")
		"jump":
			play("flystart")
		"dash":
			play("walking")
		"dashend":
			play("walking")
		"die":
			play("die")
		_:
			pass
