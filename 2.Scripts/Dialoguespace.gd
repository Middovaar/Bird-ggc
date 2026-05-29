extends RichTextLabel

signal ExpectedPress()


# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_pressed("Jump"):
		emit_signal("ExpectedPress")
