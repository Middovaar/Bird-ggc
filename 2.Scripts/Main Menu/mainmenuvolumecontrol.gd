extends HSlider


@export_enum("sfx", "music") var volumeSliderType:String
@export_range(0.01, 1.0, 0.01, "suffix:/f") var VolumeIncreaseStrength:float = 0.5
var Targetvolumes:Vector2 = Vector2.ZERO
var RealVolumes:Vector2 = Vector2.ZERO


## Lazily reads the new volume value
var ReadsVolumeValue:bool = false

## Emits the intended volume value to Master
signal PlayTestDoot()

func _ready():
	set_value_no_signal(50.0)

func _on_value_changed(value):
	Volume.ChangedVol = true
	if ReadsVolumeValue:
		match volumeSliderType:
			"sfx":
				Targetvolumes.x = value
			"music":
				Targetvolumes.y = value
	else: pass

func _on_timer_timeout():
	match volumeSliderType:
		"sfx":
			RealVolumes.x = roundf(lerpf(RealVolumes.x, Targetvolumes.x, VolumeIncreaseStrength))
			Volume.SFX = RealVolumes.x
			
		"music":
			RealVolumes.y = roundf(lerpf(RealVolumes.y, Targetvolumes.y, VolumeIncreaseStrength))
			Volume.Music = RealVolumes.y


## Starts lazily reading when the player interacts with the slider
func _on_drag_started():
	ReadsVolumeValue = true

func _on_drag_ended(value_changed):
	if volumeSliderType == "sfx":
		emit_signal("PlayTestDoot")
		
	ReadsVolumeValue = false
