extends Node2D

@onready var GameOverScreen = preload("res://1.Scenes/GameOverScreen.res").instantiate()
@onready var WinScreen = preload("res://1.Scenes/WinScreen.res").instantiate()
signal ExitGame

## Death Slowdown Factor
var PlayerDeath:bool = false
var DeathSlowdownFactor:float = 1.0
signal PlayerDead()

## Win Factor
signal PlayerWin()

# Called when the node enters the scene tree for the first time.
func _ready():
	GameOverScreen = preload("res://1.Scenes/GameOverScreen.res").instantiate()
	WinScreen = preload("res://1.Scenes/WinScreen.res").instantiate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Quit"):
		_on_player_player_death()


func _on_player_player_death():
	%Camera.add_child(GameOverScreen)
	get_node("%Camera/GameOverScreen").z_index = 2
	get_node("%Camera/GameOverScreen").connect("LetsGoBack", _on_LetsGoBack)
	emit_signal("PlayerDead")
	%Player.FreezeEverything = true

func _on_LetsGoBack():
	emit_signal("ExitGame")


func _on_player_player_win():
	%Camera.add_child(WinScreen)
	get_node("%Camera/WinScreen").z_index = 2
	get_node("%Camera/WinScreen").connect("LetsGoBack", _on_LetsGoBack)
	emit_signal("PlayerWin")
	%Player.FreezeEverything = true
	
