extends Node2D

const StartActive:Vector2 = Vector2(0.0, -1200.0)
signal StartGame
signal StartCredits
signal StartSettings

var Start:bool = false
var MoveToSides:bool = false
var MoveInCredits:bool = false
var MoveInSettings:bool = false

var progress:float = 0.0
var creditsprogress:float = 0.0

@onready var Cover = %Coverlayer

func _process(delta):
	print(str(MoveToSides) + ", " + str(MoveInCredits) + ", " + str(MoveInSettings))
	if Start:
		progress = clamp(progress+0.01, 0.0, 1.0)
		if Cover != null:
			Cover.position.y = 600-1800*EaseInOut(progress)
	
	
	if MoveToSides:
		progress = clamp(progress+0.01, 0.0, 1.0)
		$MainControlPoints.position.y = 0-1920*EaseInOut(progress)
	
	elif MoveToSides == false:
		progress = clamp(progress-0.01, 0.0, 1.0)
		$MainControlPoints.position.y = 0-1920*EaseInOut(progress)
	
	
	if MoveInCredits:
		creditsprogress = clamp(creditsprogress+0.01, 0.0, 1.0)
		$CreditsControlPoints.position.x = 1920-1920*EaseInOut(creditsprogress)
	elif MoveInCredits == false:
		creditsprogress = clamp(progress-0.01, 0.0, 1.0)
		$CreditsControlPoints.position.x = 1920-1920*EaseInOut(creditsprogress)
		
	if MoveInSettings:
		creditsprogress = clamp(creditsprogress+0.01, 0.0, 1.0)
		$SettingsControlPoints.position.x = -1920+1920*EaseInOut(creditsprogress)
	elif MoveInSettings == false:
		creditsprogress = clamp(progress-0.01, 0.0, 1.0)
		$SettingsControlPoints.position.x = -1920+1920*EaseInOut(creditsprogress)


func EaseInOut(val:float) -> float: 
	# Normalize the input to the domain of the function
	var x = clamp(val, 0.0, 1.0)
	if x < 0.5:
		return 2.0 * x * x
	else:
		return 1.0 - pow(-2.0 * x + 2.0, 2.0) / 2.0

func MoveToSide(form) -> void:
	MoveToSides = true
	match form:
		"Settings":
			MoveInSettings = true
			emit_signal("StartSettings")
		"Credits":
			MoveInCredits = true
			emit_signal("StartCredits")

func _on_ButtonPress(Type):
	match Type:
		"Start":
			Start = true
			await get_tree().create_timer(1.0).timeout
			Cover = null
			for children in get_children():
				children.queue_free()
			emit_signal("StartGame")
		"Settings":
			MoveToSide(Type)
		"Credits":
			
			MoveToSide(Type)
		"Exit":
			get_tree().quit(0)

func reentersScope():
	Start = false
	MoveToSides = false
	MoveInCredits = false
	MoveInSettings = false

func _on_button_letsgo_back():
	reentersScope()
