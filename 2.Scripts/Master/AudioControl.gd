extends AudioStreamPlayer2D

const MaxVol:float = 0.95
const MinVol:float = 0

@export_enum("sfx", "music") var VolumeEmmiterType:String
@export var TestDoot:AudioStreamMP3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
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
			pass
