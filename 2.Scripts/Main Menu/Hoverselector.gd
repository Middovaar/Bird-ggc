extends Sprite2D

var Positions:Dictionary = {
	"Start": Vector2(960.0, 180.0),
	"Settings": Vector2(960.0, 270.0),
	"Credits": Vector2(960.0, 360.0),
	"Exit": Vector2(960.0, 450.0),
	"Avoid": Vector2(960.0, 780.0),
}

var PosGoTo:Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	self.position = Positions["Avoid"]
	PosGoTo = Positions["Avoid"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = lerp(self.position, PosGoTo, 0.04)


func _on_button_gardine_select_highlighter_pos(Type):
	if Positions[Type] != null:
		PosGoTo = Positions[Type]
