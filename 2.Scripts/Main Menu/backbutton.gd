extends NinePatchRect

@onready var Unhover = preload("res://Assets/Menu UI/Menu/ui_key_square.png")
@onready var Hover = preload("res://Assets/Menu UI/Menu/ui_key_square_hover.png")
@onready var Click = preload("res://Assets/Menu UI/Menu/ui_key_square_press.png")

var IsHovered:bool = false

signal LetsgoBack()
signal LetsGoBackHover()

func _on_mouse_entered():
	emit_signal("LetsGoBackHover")
	IsHovered = true
	texture = Hover

func _on_mouse_exited():
	IsHovered = false
	texture = Unhover
	

func _on_gui_input(_event):
	if IsHovered == true and Input.is_action_just_pressed("ui_accept"):
		texture = Click
		emit_signal("LetsgoBack")
	elif IsHovered == true and Input.is_action_just_released("ui_accept"):
		texture = Hover
