extends Node2D

signal ExitGame

## Death Slowdown Factor
var PlayerDeath:bool = false
var DeathSlowdownFactor:float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_player_exit_game():
	emit_signal("ExitGame")


func _process(_delta):
	if PlayerDeath:
		DeathSlowdownFactor = clamp(DeathSlowdownFactor-0.01, 0.02, 1.0)

func _on_player_death_slowdown_announcer():
	PlayerDeath = true
