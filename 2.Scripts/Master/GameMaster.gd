extends Node2D

@onready var Game = preload("res://1.Scenes/TheFinalGameHead.tscn").instantiate()
@onready var MainMenu = preload("res://1.Scenes/MainMenu.tscn").instantiate()

## What are we exiting from. HAS TO BE THE TRUE NAME OF THE NODE
var WhatToExitFrom:String


func _on_main_menu_start_game():
	## Where are we exiting from?
	WhatToExitFrom = "MainMenu"
	QueueFreeEr()
	## Where are we going to?
	add_child(Game)
	## Make sure to connect the QuitGame signal, so we can exit to the Main Menu.
	get_node("TheFinalGameHead").connect("ExitGame", _on_exit_Game)

func _on_exit_Game():
	## Where are we exiting from?
	WhatToExitFrom = "TheFinalGameHead"
	QueueFreeEr()
	## Where are we going to?
	add_child(MainMenu)
	## You have to re-ready these so the game can open them again
	Game = preload("res://1.Scenes/TheFinalGameHead.tscn").instantiate()
	MainMenu = preload("res://1.Scenes/MainMenu.tscn").instantiate()
	## Connect the StartGame signal from Main Menu so that the head can enter the Game
	get_node("MainMenu").connect("StartGame", _on_main_menu_start_game)

func QueueFreeEr() -> void:
	## Free the intended node
	get_node(WhatToExitFrom).queue_free()
