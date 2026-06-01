extends RichTextLabel

var OriginalText

@export_enum("Name", "Role", "Special") var NamePlateType
@export_enum("Jette", "Quinn", "West", "Tolz", "Pam", "Yun") var Person
@export var UseThisText:String
@export var AlternateText:String

const WaverOpener:String = "[wave amp=36.0 freq=5.5]"
const WaverCloser:String = "[/wave]"

const ItalicOpener:String = "[i]"
const ItalicCloser:String = "[/i]"

var Selected:bool
var progress:float = 1.0
var UsingAlternateText:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if NamePlateType == 1:
		self.text = ItalicOpener+UseThisText+ItalicCloser
	else:
		self.text = UseThisText

func _on_mouse_entered():
	if UsingAlternateText == false:
		if NamePlateType == 1:
			self.text = WaverOpener+ItalicOpener+UseThisText+ItalicCloser+WaverCloser
		else:
			self.text = WaverOpener+UseThisText+WaverCloser
	else:
		if NamePlateType == 1:
			self.text = WaverOpener+ItalicOpener+AlternateText+ItalicCloser+WaverCloser
		else:
			self.text = WaverOpener+AlternateText+WaverCloser


func _on_mouse_exited():
	if UsingAlternateText == false:
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
	else:
		if Selected != true:
			if NamePlateType == 1:
				self.text = ItalicOpener+AlternateText+ItalicCloser
			else:
				self.text = AlternateText
		else:
			if NamePlateType == 1:
				self.text = WaverOpener+ItalicOpener+AlternateText+ItalicCloser+WaverCloser
			else:
				self.text = WaverOpener+AlternateText+WaverCloser


func _on_gui_input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		if Selected == false:
			Selected = true
			if NamePlateType == 2:
				UsingAlternateText = true
				self.text = WaverOpener+AlternateText+WaverCloser
		else:
			Selected = false
			UsingAlternateText = false
