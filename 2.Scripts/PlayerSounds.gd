extends AudioStreamPlayer2D


var SFXDict:Dictionary = {
	"walk": preload("res://SOUND/SFX/Player SFX/player_walk.mp3"),
	"light": preload("res://SOUND/SFX/Player SFX/player_attack_light.mp3"),
	"heavy": preload("res://SOUND/SFX/Player SFX/player_attack_heavy.mp3"),
	"dash": preload("res://SOUND/SFX/Player SFX/player_dash.mp3"),
	"jump": preload("res://SOUND/SFX/Player SFX/player_jump.mp3"),
	"hurt": preload("res://SOUND/SFX/Player SFX/player_hurt.mp3"),
}

var ReadiedSFX
var MayLoop = false


func _input(event):
	if Input.is_action_just_pressed("Dash"):
		ReadiedSFX = "dash"

func _on_player_soundtobeplayed(SFX):
	if ReadiedSFX == SFX:
		pass
	if ReadiedSFX != SFX:
		ReadiedSFX = SFX
		PlayNewAudio()

func PlayNewAudio():
	match ReadiedSFX:
		"walk":
			self.set_stream(SFXDict["walk"])
			MayLoop = true
			play()
		"grounddash":
			self.set_stream(SFXDict["dash"])
			MayLoop = false
			play()
		"jumpdash":
			self.set_stream(SFXDict["dash"])
			MayLoop = false
			play()
		"dash":
			self.set_stream(SFXDict["dash"])
			MayLoop = false
			play()
		"startjump":
			self.set_stream(SFXDict["jump"])
			MayLoop = false
			play()
		"hurt":
			self.set_stream(SFXDict["hurt"])
			MayLoop = false
			play()
		"heavyatk":
			self.set_stream(SFXDict["heavy"])
			MayLoop = false
			play()
		"lightatk":
			self.set_stream(SFXDict["light"])
			MayLoop = false
			play()
		_:
			MayLoop = false


func _on_finished():
	if MayLoop:
		await get_tree().create_timer(0.12).timeout
		play()
