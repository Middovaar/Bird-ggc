extends Node2D

@onready var GameOverScreen = preload("res://1.Scenes/GameOverScreen.res").instantiate()
signal ExitGame


# Called when the node enters the scene tree for the first time.
func _ready():
	GameOverScreen = preload("res://1.Scenes/GameOverScreen.res").instantiate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Quit"):
		emit_signal("ExitGame")


func _on_player_player_death():
	add_child(GameOverScreen)
	get_node("GameOverScreen").connect("LetsGoBack", _on_LetsGoBack)

func _on_LetsGoBack():
	emit_signal("ExitGame")
