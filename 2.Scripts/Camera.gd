extends Camera2D

#region Camera Paramters
@export_category("Camera Paramters")
#region Camera Movement Parameters
@export_subgroup("Camera Movement Paramters")
## Camera Position Speed
## [br] [br]
## Expressed in "speed" or /S (per Sp), it controls how rapidly the camera will adjust itself to reach intended values while in-movement
## Having the value be [code]0.0[/code] means that there will be no animation
## [br] [br]
## [b]Base Value[/b] = [code]0.03 speed[/code]
@export_range(0.00, 1.00, 0.02, "prefer_slider", "suffix:/Sp") var CamPositionSpeed:float = 0.3
#endregion
#region Camera Zoom Parameters
@export_subgroup("Camera Zoom Paramters")
## Mini Zoom Factor
## [br] [br]
## What is the camera zoom when standing still?
## Assymetric scaling creates a skewed camera
## [br] [br]
## [b]Base Value[/b] = [code]Vector2(1.8, 1.8)[/code]
@export var MiniZoomStrength:Vector2 = Vector2(1.8, 1.8)
## Normal Zoom Factor
## [br] [br]
## What is the camera zoom when walking or just stopping?
## Assymetric scaling creates a skewed camera
## [br] [br]
## [b]Base Value[/b] = [code]Vector2(1.0, 1.0)[/code]
@export var NormalZoomStrength:Vector2 = Vector2(1.0, 1.0)
## Maxi Zoom Factor
## [br] [br]
## What is the camera zoom when dashing?
## Assymetric scaling creates a skewed camera
## [br] [br]
## [b]Base Value[/b] = [code]Vector2(0.6, 0.6)[/code]
@export var MaxiZoomStrength:Vector2 = Vector2(0.6, 0.6)
## Camera Low Zoom Speed
## [br] [br]
## Expressed in "centispeed" or /cSp (per cSp), it controls how rapidly the camera will adjust its zoom based on player velocity.
## This controls the speed in the Low Speed regime (Standing Still), where it slowly zooms in if there is no player input
## [br] [br]
## [b]Base Value[/b] = [code]1.8 centispeed[/code]
@export_range(0.0, 0.5, 0.02, "prefer_slider", "suffix:/mSp") var CamLowZoomSpeed:float = 0.18
## Camera High Zoom Speed
## [br] [br]
## Expressed in "centispeed" or /cSp (per cSp), it controls how rapidly the camera will adjust its zoom based on player velocity.
## This controls the speed in the High Speed regime (Walking, Dashing), where it zooms out at various degrees depending on player input
## [br] [br]
## [b]Base Value[/b] = [code]1.0 centispeed[/code]
@export_range(0.0, 5.0, 0.2, "prefer_slider", "suffix:/mSp") var CamHighZoomSpeed:float = 1.0
#endregion
#endregion

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y = lerpf(position.y, %Player.position.y, CamPositionSpeed/10)
	#position.x = lerpf(position.x, %Player.position.x + %Player.velocity.x*0.3, CamPositionSpeed*0.5)
	position.x = lerpf(position.x, %Player.position.x, CamPositionSpeed*0.5)
										#L this should be a special
	
	#if %Player.AcceleratingDirection == Vector2(1,1) or %Player.AcceleratingDirection == Vector2(0,0) and %Player.IsDashing == 0:
		#position = lerp(position, %Player.position, CamPositionSpeed)
		#zoom = lerp(zoom, MiniZoomStrength, CamLowZoomSpeed*0.01)
	#else:
		#if %Player.IsDashing == 1:
			#zoom = lerp(zoom, MaxiZoomStrength, CamHighZoomSpeed*0.001)
		#else:
			#zoom = lerp(zoom, NormalZoomStrength, (CamHighZoomSpeed*6)*0.001)
	##
	#pass
