extends AnimatedSprite2D


func _on_klo_animation_changer(EmittingAnimation):
	match EmittingAnimation:
		"idle":
			play("idle")
		"walk":
			play("walk")
		"jump":
			play("flystart")
		"dash":
			play("flystart")
		"dashend":
			play("dashend")
