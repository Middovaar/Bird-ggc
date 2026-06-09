extends AudioStreamPlayer2D

const MaxVol:float = 0.95
const MinVol:float = 0

@export_enum("sfx", "music") var VolumeEmmiterType:String
@export var TestDoot:AudioStreamMP3
@export var HitConf:AudioStreamMP3

@export var MusicPlayed:String = ""


@onready var comicMusic:AudioStreamMP3 = load("uid://botnqfithkd4b")

var WhereAreWe:String

# Called when the node enters the scene tree for the first time.
func _ready():
	Volume.SFX = 0.5
	volume_db = -8.5

func _process(delta):
	if Volume.ChangedVol == true:
		match VolumeEmmiterType:
			"sfx":
				volume_linear = remap(Volume.SFX, 0.0, 100.0, MinVol, MaxVol)
			"music":
				volume_linear = remap(Volume.Music, 0.0, 100.0, MinVol, MaxVol)

func _on_PlayTestDoot():
	self.stream = TestDoot
	play()

func _on_finished():
	match self.stream:
		TestDoot:
			self.stream = null
		_:
			MusicPlayed = MusicPlayed
		
	match MusicPlayed:
		"":
			return
		"start":
			self.stream = comicMusic
			self.play()
		"comic":
			if WhereAreWe == "comic":
				self.play()
			else:
				return
		
		_:
			return
