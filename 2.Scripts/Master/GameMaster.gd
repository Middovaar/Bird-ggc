extends Node2D

@onready var Game = load("res://1.Scenes/TheFinalGameHead.tscn").instantiate()
@onready var MainMenu = load("res://1.Scenes/MainMenu.tscn").instantiate()
@onready var Comic = load("uid://by712xqrac58n").instantiate()

## What are we exiting from. HAS TO BE THE TRUE NAME OF THE NODE
var WhatToExitFrom:String

##
signal PlayTestDoot()

func _on_main_menu_start_game():
	## Where are we exiting from?
	WhatToExitFrom = "MainMenu"
	QueueFreeEr()
	## Where are we going to?
	await get_tree().create_timer(0.3).timeout
	add_child(Comic)
	## Make sure to connect the QuitGame signal, so we can exit to the Main Menu.
	get_node("ComicInstantiator").connect("ComicDone", _onComicDone)
	get_node("ComicInstantiator").connect("SkipComic", _onComicDone)

func _onComicDone():
	WhatToExitFrom = "ComicInstantiator"
	QueueFreeEr()
	await get_tree().create_timer(0.3).timeout
	add_child(Game)
	get_node("TheFinalGameHead").connect("ExitGame", _on_exit_Game)

func _on_exit_Game():
	## Where are we exiting from?
	WhatToExitFrom = "TheFinalGameHead"
	QueueFreeEr()
	## Where are we going to?
	add_child(MainMenu)
	## You have to re-ready these so the game can open them again
	Game = load("res://1.Scenes/TheFinalGameHead.tscn").instantiate()
	MainMenu = load("res://1.Scenes/MainMenu.tscn").instantiate()
	## Connect the StartGame signal from Main Menu so that the head can enter the Game
	get_node("MainMenu").connect("StartGame", _on_main_menu_start_game)
	## Connect the TestDoot signal so that the SFX volume slider works propperly
	get_node("MainMenu").connect("PlayTestDoot", _on_PlayTestDoot())

func QueueFreeEr() -> void:
	## Free the intended node
	get_node(WhatToExitFrom).queue_free()


func _on_PlayTestDoot():
	emit_signal("PlayTestDoot")
