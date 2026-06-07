extends Node2D

@onready var ComicPage1:PackedScene = preload("uid://cecd1ouq0xur5")
@onready var ComicPage2:PackedScene = preload("uid://b3cvk4q322fjr")
@onready var ComicPage3:PackedScene = preload("uid://drg8h6ddi2kpc")
@onready var ComicPage4:PackedScene = preload("uid://rbonlhrti3ph")
@onready var ComicPage5:PackedScene = preload("uid://smmdmjd68128")
@onready var ComicPage6:PackedScene = preload("uid://demtsfkfhtsd0")
@onready var ComicPage7:PackedScene = preload("uid://bxwupon0ilqeo")
@onready var ComicPage8:PackedScene = preload("uid://13hx6d3o3e03")

var OnPage = 1

var BackgroundPosition = 2510.0
signal ComicDone()
signal SkipComic()

func _ready():
	add_child(ComicPage1.instantiate())
	get_child(1).connect("HitUpNextPage", _onComicFinishReading)

func _onComicFinishReading():
	ScrollBackground()
	await get_tree().create_timer(0.6).timeout
	get_child(1).free()
	OnPage += 1
	NextPage(OnPage)

func NextPage(Page):
	match Page:
		1:
			add_child(ComicPage1.instantiate())
			get_child(1).connect("HitUpNextPage", _onComicFinishReading)
		2:
			add_child(ComicPage2.instantiate())
			get_child(1).connect("HitUpNextPage", _onComicFinishReading)
		3:
			add_child(ComicPage3.instantiate())
			get_child(1).connect("HitUpNextPage", _onComicFinishReading)
		4:
			add_child(ComicPage4.instantiate())
			get_child(1).connect("HitUpNextPage", _onComicFinishReading)
		5:
			add_child(ComicPage5.instantiate())
			get_child(1).connect("HitUpNextPage", _onComicFinishReading)
		6:
			add_child(ComicPage6.instantiate())
			get_child(1).connect("HitUpNextPage", _onComicFinishReading)
		7:
			add_child(ComicPage7.instantiate())
			get_child(1).connect("HitUpNextPage", _onComicFinishReading)
		_:
			add_child(ComicPage8.instantiate())
			get_child(1).connect("Done", _onDone)

func _process(_delta):
	$Background.position.x = lerpf($Background.position.x, BackgroundPosition, 0.05)
	if Input.is_action_just_pressed("Quit"):
		emit_signal("SkipComic")

func ScrollBackground():
	BackgroundPosition -= 410

func _onDone():
	emit_signal("ComicDone")
