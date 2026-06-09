extends Node2D

@onready var Game = load("res://1.Scenes/TheFinalGameHead.tscn").instantiate()
@onready var MainMenu = load("res://1.Scenes/MainMenu.tscn").instantiate()
@onready var Comic = load("uid://by712xqrac58n").instantiate()

## What are we exiting from. HAS TO BE THE TRUE NAME OF THE NODE
var WhatToExitFrom:String

## Audio
signal PlayTestDoot()

## Audio SFX Catalogue
@onready var buttonPress = load("uid://cisxfwf10vrt3")
@onready var buttonHover = load("uid://4dsj1d6ifwlt")

#player
@onready var hurt:AudioStreamMP3 = load("uid://boee1novoh3v7")
@onready var jump:AudioStreamMP3 = load("uid://boee1novoh3v7")
@onready var walk:AudioStreamMP3 = load("uid://boee1novoh3v7")
@onready var dash:AudioStreamMP3 = load("uid://boee1novoh3v7")
@onready var atkheavy:AudioStreamMP3 = load("uid://boee1novoh3v7")
@onready var atklight:AudioStreamMP3 = load("uid://boee1novoh3v7")


## Music Catalogue
@onready var comicMusic:AudioStreamMP3 = load("uid://botnqfithkd4b")
@onready var PlayMusic:AudioStreamMP3 = load("uid://den5inkpudl5e")


func _on_main_menu_start_game():
	$AudioMusic.WhereAreWe = "comic"
	## Where are we exiting from?
	WhatToExitFrom = "MainMenu"
	QueueFreeEr()
	## Where are we going to?
	await get_tree().create_timer(0.3).timeout
	add_child(Comic)
	## Make sure to connect the QuitGame signal, so we can exit to the Main Menu.
	get_node("ComicInstantiator").connect("ComicDone", _onComicDone)
	get_node("ComicInstantiator").connect("SkipComic", _onComicDone)
	get_node("ComicInstantiator").connect("SoundFX", _OnSFXCall)
	get_node("ComicInstantiator").connect("MusicFX", _OnMusicCall)


func _onComicDone():
	$AudioMusic.WhereAreWe = "game"
	$AudioMusic.stop()
	$AudioSFX.stop()
	WhatToExitFrom = "ComicInstantiator"
	QueueFreeEr()
	await get_tree().create_timer(0.3).timeout
	add_child(Game)
	get_node("TheFinalGameHead").connect("ExitGame", _on_exit_Game)
	get_node("TheFinalGameHead").connect("SoundFX", _OnSFXCall)
	get_node("TheFinalGameHead").connect("MusicFX", _OnMusicCall)
	

func _on_exit_Game():
	## Where are we exiting from?
	WhatToExitFrom = "TheFinalGameHead"
	QueueFreeEr()
	## Where are we going to?
	add_child(MainMenu)
	## You have to re-ready these so the game can open them again
	Game = load("res://1.Scenes/TheFinalGameHead.tscn").instantiate()
	MainMenu = load("res://1.Scenes/MainMenu.tscn").instantiate()
	Comic = load("uid://by712xqrac58n").instantiate()
	## Connect the StartGame signal from Main Menu so that the head can enter the Game
	get_node("MainMenu").connect("StartGame", _on_main_menu_start_game)
	## Connect the TestDoot signal so that the SFX volume slider works propperly
	get_node("MainMenu").connect("PlayTestDoot", _on_PlayTestDoot)
	get_node("MainMenu").connect("SoundFX", _OnSFXCall)
	get_node("MainMenu").connect("MusicFX", _OnMusicCall)

func QueueFreeEr() -> void:
	## Free the intended node
	get_node(WhatToExitFrom).queue_free()

func _on_PlayTestDoot():
	emit_signal("PlayTestDoot")

func _OnSFXCall(SFX:String) -> void:
	match SFX:
		"menuButton":
			$AudioSFX.stream = buttonPress
			$AudioSFX.play()
		
		"buttonHover":
			$AudioSFX.stream = buttonHover
			$AudioSFX.play()
		
		## PLayer SFXes
		"walk":
			$AudioSFX.stream = walk
			$AudioSFX.play()
		"jump":
			$AudioSFX.stream = jump
			$AudioSFX.play()
		"dash":
			$AudioSFX.stream = dash
			$AudioSFX.play()
		"atkheavy":
			$AudioSFX.stream = atkheavy
			$AudioSFX.play()
		"atklight":
			$AudioSFX.stream = atklight
			$AudioSFX.play()
		"hurt":
			$AudioSFX.stream = hurt
			$AudioSFX.play()
		
		_:
			return

func _OnMusicCall(Music:String) -> void:
	match Music:
		"comic":
			print("a")
			$AudioMusic.stream = comicMusic
			$AudioMusic.MusicPlayed = "comic"
			$AudioMusic.play()
		"start":
			$AudioMusic.stream = PlayMusic
			$AudioMusic.MusicPlayed = "start"
			$AudioMusic.play()
		
		
		_:
			return
