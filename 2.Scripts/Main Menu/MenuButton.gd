extends RichTextLabel

@export_enum("Start", "Settings", "Credits", "Exit") var ButtonType:String

@export_category("Text")
@export var DisplayedText:String

var MouseInside:bool
signal ButtonFocus(Type)
signal ButtonClick(Type)
signal ButtonEscapeAllTypes(Type)

const CenterOpener:String = "[center]"
const CenterCloser:String = "[/center]"

const FSOpener:String = "[font_size="
const FSOpenClose:String = "]"
const FontSizeCloser:String = "[/font_size]"

var Startfontsize:float = 76
var Otherfontsize:float = 62


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if ButtonType == "Start":
		self.text = FSOpener+str(roundi(Startfontsize))+FSOpenClose+CenterOpener+DisplayedText+CenterCloser+FontSizeCloser
	elif MouseInside:
		self.text = FSOpener+str(roundi(Otherfontsize))+FSOpenClose+CenterOpener+DisplayedText+CenterCloser+FontSizeCloser
	else:
		self.text = FSOpener+str(roundi(Otherfontsize))+FSOpenClose+CenterOpener+"[i]"+DisplayedText+"[/i]"+CenterCloser+FontSizeCloser

func _on_mouse_entered():
	if Rect2(Vector2(),size).has_point(get_local_mouse_position()):
		MouseInside = true
		emit_signal("ButtonFocus", ButtonType)
	
	


func _on_mouse_exited():
	if not Rect2(Vector2(),size).has_point(get_local_mouse_position()):
		MouseInside = false
		emit_signal("ButtonEscapeAllTypes", ButtonType)


func _on_gui_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("ButtonClick", ButtonType)
		
