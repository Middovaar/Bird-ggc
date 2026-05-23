extends CharacterBody2D

@export_subgroup("")
@export var Player:Node
@export var Anim:Node
@export var Phase:int = 3
@export_enum("left", "right", "idle") var DirectionInput:String

@export_subgroup("Player Movement")
## Base Max Movement Speed measured in pixels per delta-time.
## [br] [br]
## This can be considered the normal max walking speed for the player if they are walking forwards, no dashing, just normal walking
## [br] [br]
## [b]Base value[/b] = [code]300.0px/Δt[/code]
@export_range(10.0, 1000.0, 5.0, "or_greater", "prefer_slider", "suffix:px/Δt") var BaseMovSpeed:float = 400.0 
## Acceleration of Kloe.
## [br] [br]
## This can be considered how fast Kloe reaches max speed
## [br] [br]
## [b]Base value[/b] = [code]300.0px/Δt^2[/code]
@export_range(0.0, 4.0, 0.05, "or_greater", "prefer_slider", "suffix:px/Δt^2") var AccelerationRate:float = 1.0
## Decceleration of Kloe.
## [br] [br]
## This can be considered how fast Kloe gets to stand still
## [br] [br]
## [b]Base value[/b] = [code]300.0px/Δt^2[/code]
@export_range(0.0, 4.0, 0.05, "or_greater", "prefer_slider", "suffix:px/Δt^2") var DeccelerationRate:float = 0.3

## Movement Space Tolerance
## [br] [br]
## When should Kloe consider himself to stand "on top of Saffron" in the X-axis? Setting this value to 0 means that Kloe will
## never consider himself to be on top of Saffron, and will constantly make adjustments.
## [br] [br]
## [b]Base value[/b] = [code]150.0px[/code]
@export_range(0.0, 500.0, 2.0, "or_greater", "prefer_slider", "suffix:px") var MovementSpaceTolerance:float = 75.0
## Dash Threshold Tolerance
## [br] [br]
## When should Kloe consider himself to be far enough away from Saffron to dash
## [br] [br]
## [b]Base value[/b] = [code]400.0px[/code]
@export_range(100.0, 500.0, 2.0, "or_greater", "prefer_slider", "suffix:px") var DashThresholdTolerance:float = 400.0
## Max Dash Speed
## [br] [br]
## How much speed should a Dash add?
## [br] [br]
## [b]Base value[/b] = [code]300.0px/Δt[/code]
@export_range(10.0, 1000.0, 5.0, "or_greater", "prefer_slider", "suffix:px/Δt") var MaxDashSpeed:float = 450.0 
## Base Max Jumping Speed measured in pixels per delta-time
## [br] [br]
## This technically controls the -Y impulse velocity vector, →𝑽; which in turn determines jump strength, [b]not height[/b]
## Does not determine the strength of the dash.
## [br] [br]
## [b]Base Value[/b] = [code]-400.0px/Δt[/code]
@export_range(-900.0, -100.0, 5.0, "or_less", "prefer_slider", "suffix:px/Δt") var JumpSpeed:float = -1000.0

var vel:float
var Desireposition
var MayStartThinking:bool = true

var InputKeyPushedDown:float = 0.0
var Direction:int
var NormalizedSpeed:float

var DashSpeed:float = 0.0

var HasDashed:bool = false


var PlayerBossDistanceDiscrepancy:Vector2

signal AnimationChanger(EmittingAnimation)


func _ready():
	Animationassigner(null)
	pass


func KloeReactionTime():
	if MayStartThinking: 
		KloeBrain()

func KloeBrain():
	PlayerBossDistanceDiscrepancy =  Player.get_position() - self.position
	
	if is_on_floor():
		if PlayerBossDistanceDiscrepancy.x < 0.0 - MovementSpaceTolerance:
			DirectionInput = "left"
		if PlayerBossDistanceDiscrepancy.x > 0.0 + MovementSpaceTolerance:
			DirectionInput = "right"
		if abs(PlayerBossDistanceDiscrepancy.x) < MovementSpaceTolerance:
			DirectionInput = "idle"
		
	if abs(PlayerBossDistanceDiscrepancy.x) >= DashThresholdTolerance:
		if HasDashed != true:
			DashSpeed = Dash()
			HasDashed = true
	
	if is_on_floor() and abs(PlayerBossDistanceDiscrepancy.x) < (MovementSpaceTolerance + 100):
		if abs(PlayerBossDistanceDiscrepancy.y) > 80:
			velocity.y = Jump()


func _physics_process(delta):
	#region Gravity
	### Gravity Handler
	if not is_on_floor():
		velocity += get_gravity() * delta
	#endregion
	
	#region Movement Generator # Simulates a Keypress
	### Simulating a Keypress
	match DirectionInput:
		"right":
			Direction = 1
			if InputKeyPushedDown < 100:
				InputKeyPushedDown += AccelerationRate
		"left":
			Direction = -1
			if InputKeyPushedDown < 100:	
				InputKeyPushedDown += AccelerationRate
		_:
			Direction = 0
			if InputKeyPushedDown > 0:
				InputKeyPushedDown -= DeccelerationRate
			if InputKeyPushedDown < 0:
				InputKeyPushedDown += DeccelerationRate
			if InputKeyPushedDown == 0:
				pass
		
	# convert InputKeyPushedDown -1 to +1 >> Normalized Speed so we get the Ease I/O
	NormalizedSpeed = EaseInOut(abs(InputKeyPushedDown)/100) #typecast to float, divide by 100
	velocity.x = CalculateSpeed(NormalizedSpeed)+DashSpeed
	# decay the DashSpeed
	if DashSpeed > 0:
		DashSpeed -= 5
	if DashSpeed < 0:
		DashSpeed += 5
	#endregion
	
	#region Handle SpriteFlipping
	match DirectionInput: 
		"left":
			Anim.scale.x = 0.1
		"right":
			Anim.scale.x = -0.1
	#endregion

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	move_and_slide()


func walking(direction:String) -> int:
	match direction:
		"left":
			return -1
		"right":
			return 1
		"idle":
			return 0
		_:
			return 0

## Ease I-O function that controls the acceleration of the player etc.
func EaseInOut(val:float) -> float: 
	# Normalize the input to the domain of the function
	var x = clamp(val, 0.0, 1.0)
	if x < 0.5:
		return 2.0 * x * x
	else:
		return 1.0 - pow(-2.0 * x + 2.0, 2.0) / 2.0
		

func CalculateSpeed(speed:float) -> float:
	var DressedSpeed:float
	match Direction:
		1:
			DressedSpeed = speed*BaseMovSpeed*Direction
		-1:
			DressedSpeed = speed*BaseMovSpeed*Direction
		0:
			DressedSpeed *= 0.5
		_:
			DressedSpeed = speed*BaseMovSpeed*Direction
	return DressedSpeed

func Dash():
	var DressedSpeed:float
	DressedSpeed = MaxDashSpeed*Direction
	Animationassigner("Dash")
	return DressedSpeed

func Jump():
	Animationassigner("Jump")
	return JumpSpeed

func Animationassigner(Special):
	print(Special)
	
	if Special == null:
		if abs(velocity.x) > 1.0 and is_on_floor():
			emit_signal("AnimationChanger", "walk")
		if abs(velocity.x) < 1.0 and is_on_floor():
			emit_signal("AnimationChanger", "idle")
		elif not is_on_floor():
			printerr("This shouldn't fire. a base animation is called while not on floor")
		
	if Special != null:
		match Special:
			"Jump":
				emit_signal("AnimationChanger", "jump")
			"Dash":
				emit_signal("AnimationChanger", "dash")
			"DashEnd":
				emit_signal("AnimationChanger", "dashend")
			_: pass
	pass

func _KloeDashTimerFinishes():
	if abs(PlayerBossDistanceDiscrepancy.y) < 400.0:
		HasDashed = false
	elif abs(PlayerBossDistanceDiscrepancy.x) > 800.0:
		HasDashed = false
	else:
		pass


func _on_anim_finished():
	#match Anim.animation:
		#"flystart":
			#if DashSpeed > 0.0 and is_on_floor():
				#Animationassigner("DashEnd")
		#"dashend":
			#Animationassigner(null)
		#_:
			#Animationassigner(null)
	pass
