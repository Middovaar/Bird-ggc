extends VBoxContainer

@export_category("Buttons")
@export var Start:Node
@export var Settings:Node
@export var Credits:Node
@export var Exit:Node

@export_category("Lerp Speed")
@export_range(0.0, 1.0, 0.01) var LerpspeedFloat:float = 0.2

enum {
	BUTTON_Null, BUTTON_Start, BUTTON_Settings, BUTTON_Credits, BUTTON_Exit
}

const Hover:float = 1.2
const Unhover:float = 0.8

const InactiveRation:float = 0.0
const ActiveRation:float = 1.2

const StartHoverFS:float = 72
const HoverFs:float = 64
const StartUnhoverFS:float = 64
const UnhoverFs:float = 52

## Current Button being hovered on
var CurrentHover:int = 0

var StartButtonSize

## Send data on to the select highlighter
signal SelectHighlighterPos(Type)

## ButtonPress Signal
var Active:bool
signal ButtonPress(Type)


func _ready():
	Active = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Active:
		#self.size_flags_stretch_ratio = lerpf(self.size_flags_stretch_ratio, ActiveRation, 0.2)
	#else:
		#self.size_flags_stretch_ratio = lerpf(self.size_flags_stretch_ratio, InactiveRation, 0.2)
	#
	
	match CurrentHover:
		0:
			UnhoverAll()
		1:
			HoverStart()
		2:
			HoverSettings()
		3:
			HoverCredits()
		4:
			HoverExit()


func UnhoverAll() -> void:
	Start.size_flags_stretch_ratio = lerpf(Start.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Start.Startfontsize = lerpf(Start.Startfontsize, StartUnhoverFS, LerpspeedFloat)
	
	Settings.size_flags_stretch_ratio = lerpf(Settings.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Settings.Otherfontsize = lerpf(Settings.Otherfontsize, UnhoverFs, LerpspeedFloat)
	
	Credits.size_flags_stretch_ratio = lerpf(Credits.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Credits.Otherfontsize = lerpf(Credits.Otherfontsize, UnhoverFs, LerpspeedFloat)
	
	Exit.size_flags_stretch_ratio = lerpf(Exit.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Exit.Otherfontsize = lerpf(Exit.Otherfontsize, UnhoverFs, LerpspeedFloat)

func HoverStart() -> void:
	Start.size_flags_stretch_ratio = lerpf(Start.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Start.Startfontsize = lerpf(Start.Startfontsize, StartHoverFS, LerpspeedFloat)
	
	Settings.size_flags_stretch_ratio = lerpf(Settings.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Settings.Otherfontsize = lerpf(Settings.Otherfontsize, UnhoverFs, LerpspeedFloat)
	
	Credits.size_flags_stretch_ratio = lerpf(Credits.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Credits.Otherfontsize = lerpf(Credits.Otherfontsize, UnhoverFs, LerpspeedFloat)
	
	Exit.size_flags_stretch_ratio = lerpf(Exit.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Exit.Otherfontsize = lerpf(Exit.Otherfontsize, UnhoverFs, LerpspeedFloat)

func HoverSettings() -> void:
	Start.size_flags_stretch_ratio = lerpf(Start.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Start.Startfontsize = lerpf(Start.Startfontsize, StartUnhoverFS, LerpspeedFloat)
	
	Settings.size_flags_stretch_ratio = lerpf(Settings.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Settings.Otherfontsize = lerpf(Settings.Otherfontsize, HoverFs, LerpspeedFloat)
	
	Credits.size_flags_stretch_ratio = lerpf(Credits.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Credits.Otherfontsize = lerpf(Credits.Otherfontsize, UnhoverFs, LerpspeedFloat)
	
	Exit.size_flags_stretch_ratio = lerpf(Exit.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Exit.Otherfontsize = lerpf(Exit.Otherfontsize, UnhoverFs, LerpspeedFloat)

func HoverCredits() -> void:
	Start.size_flags_stretch_ratio = lerpf(Start.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Start.Startfontsize = lerpf(Start.Startfontsize, StartUnhoverFS, LerpspeedFloat)
	
	Settings.size_flags_stretch_ratio = lerpf(Settings.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Settings.Otherfontsize = lerpf(Settings.Otherfontsize, UnhoverFs, LerpspeedFloat)
	
	Credits.size_flags_stretch_ratio = lerpf(Credits.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Credits.Otherfontsize = lerpf(Credits.Otherfontsize, HoverFs, LerpspeedFloat)
	
	Exit.size_flags_stretch_ratio = lerpf(Exit.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Exit.Otherfontsize = lerpf(Exit.Otherfontsize, UnhoverFs, LerpspeedFloat)

func HoverExit() -> void:
	Start.size_flags_stretch_ratio = lerpf(Start.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Start.Startfontsize = lerpf(Start.Startfontsize, StartUnhoverFS, LerpspeedFloat)
	
	Settings.size_flags_stretch_ratio = lerpf(Settings.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Settings.Otherfontsize = lerpf(Settings.Otherfontsize, UnhoverFs, LerpspeedFloat)
	
	Credits.size_flags_stretch_ratio = lerpf(Credits.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Credits.Otherfontsize = lerpf(Credits.Otherfontsize, UnhoverFs, LerpspeedFloat)
	
	Exit.size_flags_stretch_ratio = lerpf(Exit.size_flags_stretch_ratio, Unhover, LerpspeedFloat)
	Exit.Otherfontsize = lerpf(Exit.Otherfontsize, HoverFs, LerpspeedFloat)

func _OnButtonHover(ButtonType):
	match ButtonType:
		"Start":
			CurrentHover = 1
		"Settings":
			CurrentHover = 2
		"Credits":
			CurrentHover = 3
		"Exit":
			CurrentHover = 4
		_:
			CurrentHover = 0
	
	emit_signal("SelectHighlighterPos", ButtonType)

func _OnButtonClick(ButtonType):
	match ButtonType:
		"Start":
			CurrentHover = 1
		"Settings":
			CurrentHover = 2
		"Credits":
			CurrentHover = 3
		"Exit":
			CurrentHover = 4
		_:
			CurrentHover = 0
	
	Active = false
	emit_signal("ButtonPress", ButtonType)
	print("clicked ", ButtonType)


func OnButtonEscapeAllTypes(Type):
	pass


func _on_mouse_exited(): # Replace with function body.
	CurrentHover = 0
	emit_signal("SelectHighlighterPos", "Avoid")
