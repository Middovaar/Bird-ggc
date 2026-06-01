extends RichTextLabel

var OriginalText

@export_enum("Name", "Role") var NamePlateType
@export_enum("Jette", "Quinn", "West", "Tolz", "Pam", "Yun") var Person
@export var UseThisText:String


const WaverOpener:String = "[wave amp=36.0 freq=5.5]"
const WaverCloser:String = "[/wave]"

const ItalicOpener:String = "[i]"
const ItalicCloser:String = "[/i]"

var Selected:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	if NamePlateType == 1:
		self.text = ItalicOpener+UseThisText+ItalicCloser
	else:
		self.text = UseThisText


func _on_mouse_entered():
	if NamePlateType == 1:
		self.text = WaverOpener+ItalicOpener+UseThisText+ItalicCloser+WaverCloser
	else:
		self.text = WaverOpener+UseThisText+WaverCloser


func _on_mouse_exited():
	if Selected != true:
		if NamePlateType == 1:
			self.text = ItalicOpener+UseThisText+ItalicCloser
		else:
			self.text = UseThisText
	else:
		if NamePlateType == 1:
			self.text = WaverOpener+ItalicOpener+UseThisText+ItalicCloser+WaverCloser
		else:
			self.text = WaverOpener+UseThisText+WaverCloser


func _on_gui_input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		if Selected == false:
			Selected = true
		else:
			Selected = false
