extends Node2D

const StartActive:Vector2 = Vector2(0.0, -1200.0)
signal StartGame
signal StartCredits
signal StartSettings
signal PlayTestDoot()

var Start:bool = false
var MoveToSides:bool = false
var MoveInCredits:bool = false
var MoveInSettings:bool = false

var progress:float = 0.0
var startprogress:float = 0.0
var creditsprogress:float = 0.0
var settingsprogress:float = 0.0
var ShouldAccess:bool = true

@onready var Cover = %Coverlayer

func _process(delta):
	if Start and ShouldAccess:
		startprogress = clamp(startprogress+0.01, 0.0, 1.0)
		$MainControlPoints.position.y = 0-1920*EaseInOut(startprogress)
		$Sprites/CrocMastersLogo.offset.y = 0+400*EaseInOut(startprogress)
		$Coverlayer.position.y = 600-1920*EaseInOut(startprogress)
	
	if MoveToSides:
		progress = clamp(progress+0.01, 0.0, 1.0)
		$MainControlPoints.position.y = 0-1920*EaseInOut(progress)
		$Sprites/CrocMastersLogo.offset.y = 0+400*EaseInOut(progress)
	
	elif MoveToSides == false and ShouldAccess:
		progress = clamp(progress-0.01, 0.0, 1.0)
		$MainControlPoints.position.y = 0-1920*EaseInOut(progress)
		$Sprites/CrocMastersLogo.offset.y = 0+400*EaseInOut(progress)
	
	
	if MoveInCredits:
		creditsprogress = clamp(creditsprogress+0.01, 0.0, 1.0)
		$CreditsControlPoints.position.x = 1920-1920*EaseInOut(creditsprogress)
	elif MoveInCredits == false and ShouldAccess:
		creditsprogress = clamp(creditsprogress-0.01, 0.0, 1.0)
		$CreditsControlPoints.position.x = 1920-1920*EaseInOut(creditsprogress)
		
	if MoveInSettings:
		settingsprogress = clamp(settingsprogress+0.01, 0.0, 1.0)
		$SettingsControlPoints.position.x = -1920+1920*EaseInOut(settingsprogress)
	elif MoveInSettings == false and ShouldAccess:
		settingsprogress = clamp(settingsprogress-0.01, 0.0, 1.0)
		$SettingsControlPoints.position.x = -1920+1920*EaseInOut(settingsprogress)


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
			ShouldAccess = false
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


func _on_sfx_play_test_doot():
	emit_signal("PlayTestDoot")
