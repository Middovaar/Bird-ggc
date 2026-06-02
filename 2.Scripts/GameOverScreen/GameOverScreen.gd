extends Node2D

var SlideInBlack:bool = false
var SlideInBackButton:bool = false

const BotPaddingFinalSize:float = 0.65
const TopPaddingFinalSize:float = 0.50

const BackBPlacem:float = 323.0

signal LetsGoBack()

func _ready():
	get_parent().get_parent().get_parent().connect("PlayerDead", StartGameOver)

func _process(_delta):
	
	
	if SlideInBlack:
		$VBoxContainer/TopPadding.size_flags_stretch_ratio = lerpf($VBoxContainer/TopPadding.size_flags_stretch_ratio, TopPaddingFinalSize, 0.04)
		$Coverlayer.position.y = clamp($Coverlayer.position.y+100, 0.0, 1000.0)
	
	if SlideInBackButton:
		$Button.position.y = lerpf($Button.position.y, BackBPlacem, 0.05)

func StartGameOver():
	SlideInBlack = true
	await get_tree().create_timer(0.3).timeout
	SlideInBackButton = true

func _on_button_letsgo_back():
	emit_signal("LetsGoBack")
