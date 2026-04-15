extends CharacterBody2D

#region Public Variables
#region Player Parameters
@export_category("Player Parameters") 

## Max HP
## [br] [br]
## Max HP of the Player
## [br] [br]
## [b]Base Value[/b] = [code]100 HP[/code]
@export_range(1, 250, 1, "or_greater", "suffix:HP") var MaxHP:int = 100

#region Player Movement
## Base player parameters used by the game to determine what is "normal" for the player
@export_subgroup("Player Movement")
## Base Max Movement Speed measured in pixels per delta-time.
## [br] [br]
## This can be considered the normal max walking speed for the player if they are walking forwards, no dashing, just normal walking
## [br] [br]
## [b]Base value[/b] = [code]300.0px/Δt[/code]
@export_range(10.0, 1000.0, 5.0, "or_greater", "prefer_slider", "suffix:px/Δt") var BaseMovSpeed:float = 300.0 
## Time to Reach Max Speed
## [br] [br]
## Controls how fast the player acceletrates to [param BaseMovSpeed] by just walking
## [br] [br]
## [b]Base Value[/b] = [code]2.5 seconds[/code]
@export_range(0.3, 10.0, 0.1, "or_greater", "prefer_slider", "suffix:sec") var TimeToReachMaxSpeed:float = 1.0
## Base Max Jumping Speed measured in pixels per delta-time
## [br] [br]
## This technically controls the -Y impulse velocity vector, →𝑽; which in turn determines jump strength, [b]not height[/b]
## Does not determine the strength of the dash.
## [br] [br]
## [b]Base Value[/b] = [code]-400.0px/Δt[/code]
@export_range(-600.0, -100.0, 5.0, "or_less", "prefer_slider", "suffix:px/Δt") var JumpSpeed:float = -400.0

## Movement Speed Decay Factor
## [br] [br]
## Controls the speed at which movement decays over time if the Player were to release all buttons.
## Measured in Δ𝑽/Δt, essentially the decay of velocity over every second. You could also consider it to be
## the square root of acceleration. Lower values indicate slower deceleration. Higher indicates faster.
## At infinity, deceleration is instant. At 0, no deceleration happens.
## [br] [br]
## [b]Base Value[/b] = [code]4.0 Δ𝑽/Δt[/code]
@export_range(0.0, 8.0, 0.1, "or_greater", "prefer_slider", "suffix:Δ𝑽/Δt") var MovSpeedDecayFactor:float = 4.0
## Trailing Movement Speed Decay Factor
## [br] [br]
## Controls the slower decay of stored movement speed.
## Normally, when a player swaps directions in quick succession - the game uses this value to protect
## the hitherto attained velocity, thus circumventing having to use [param func EaseInOut]. This makes
## quick movement changes snappier at speed; but maintains the previous feel for slower more methodical
## movement. At 0, no decay happens. At invinity, decay is total
## [br] [br]
## [b]Base Value[/b] = [code]-0.15 Δ𝑽/Δt[/code]
@export_range(-1.0, 0.0, 0.01, "or_less", "prefer_slider", "suffix:Δ𝑽/Δt") var TrailingMovSpeedDecay:float = -0.15
## Trailing Movement Speed Decay Limit
## [br] [br]
## Controls when the game should trail the decay the movement,
## Normally, stored velocity is decayed using [param MovSpeedDecayFactor]; only to decay slower once the decay
## reaches a velocity threshold. Beyond this threshold, the value decays much more slowly, to create a snappier feel
## @experimental: Playing around with this value close to the accepted limits can create some unintended effects
## [br] [br]
## [b]Base Value[/b] = [code]50% of BaseMovSpeed[/code]
@export_range(0.0, 100, 1.0, "or_less", "prefer_slider", "suffix:%BaseMovSpeed") var TrailingMovSpdDecayLimit:float = 50
## No Input Trailing Movement Speed Decay
## [br] [br]
## Controls how fast the game should decay your speed if you release all buttons. No Input.
## This is currently set as lower than the normal ammount. [code]100%[/code] means that the slowdown is the same as the normal
## decay rate. [code]0%[/code] is the same as no slowdown. When the player releases all buttons, the player model will slide endlessly.
## @deprecated: This might cause some game-breaking glitches at [code]0%[/code] due to division errors.
## [br] [br]
## [b]Base Value[/b] = [code]37.5%[/code]
@export_range(0.0, 100, 0.5, "or_less", "prefer_slider", "suffix:%MovSpdDecay") var NoInputModSpdDecay:float = 37.5

## Is the Player able to Dash?
## [br] [br]
## This controls if the player is allowed to dash. If this is not active, pressing the Dash Button does [b]NOTHING[/b]!
## [br] [br]
## [b]Base Value[/b] = [code]true[/code]
@export var PlayerMayDash:bool = true
@export_subgroup("Player Movement/Dashing")
## Dash Strength
## [br] [br]
## A percentage factor used to calculate the speed of a dash. This a factor based on [param BaseMovSpeed] and so it is
## expressed as a percentage of that value. By increasing this value, a dash reaches higher speed when active.
## [br] [br]
## [b]Base Value[/b] = [code]2.0[/code] times [param BaseMovSpeed], i.e [code]600px/Δt[/code]
@export_range(1.0, 5.0, 0.1, "or_greater", "prefer_slider", "suffix:X") var DashStrength:float = 2.0
## Dash Time
## [br] [br]
## Expressed in seconds, this controls how long a dash lasts. Since Dashes follow a set envelope, this is the time after
## a dash when control is given back to the player.
## [br] [br]
## [b]Base Value[/b] = [code]0.4 seconds[/code]
@export_range(0.1, 1.5, 0.05, "or_greater", "prefer_slider", "suffix:sec") var DashTime:float = 0.4
## Dash Decay
## [br] [br]
## Expressed in seconds, this controls how long the effects of a dash lasts. Since Dashes follow a set envelope, this is the time after
## a dash when the player's movement speed remains elevated [b]above [param BaseMovSpeed][/b]
## [br] [br]
## [b]Base Value[/b] = [code]2.0 seconds[/code]
@export_range(0.5, 6.0, 0.1, "or_greater", "prefer_slider", "suffix:sec") var DashDecay:float = 2.0
## @experimental: Dash Resets Jump
## Should a dash into an enemy mid-air reset the player's jump?
## [br] [br]
## [b]Base Value[/b] = [code]No[/code]
@export_enum("No:0", "Only With Powerup:2", "Yes Always:1") var DashResetsJump:int = 0
## @experimental: Dash Reset Overrides Dash Decay
## If Dash resets, and if the player jumps, should they maintain the Dash decay speed, or should the player immediately slow down to normal speed?
## [br] [br]
## [b]Base Value[/b] = [code]Yes[/code]
@export_enum("No:0", "Yes:1", "Yes and the Jump Speed is affected:2") var DashResetOverridesDashDecay:int = 1
## @experimental: Dash I-frames
## Should the player be unable to be hurt if they dash?
## [br] [br]
## [b]Base Value[/b] = [code]Yes[/code] but not to [code]Enviromental Hazards[/code]
@export_enum("No:0", "Yes -Enviromental Hazards:1", "Yes:2", "Yes +Jump Speed:3") var DashIFrames:int = 1
@export_subgroup("Player Movement")
## Is the Player able to Sneak?
## [br] [br]
## This controls if the player is allowed to sneak. Sneaking happens when players push [param Left] and [param Right] at the same time!
## [br] [br]
## [b]Base Value[/b] = [code]true[/code]
@export var PlayerMaySneak:bool = true
@export_subgroup("Player Movement/Sneaking")
## Sneaking Speed
## [br] [br]
## Controls how fast sneaking is. A value of [code]0.0[/code] means the Player will immediately stop when sneaking.
## [br] [br]
## [b]Base Value[/b] = [code]70%[/code]
@export_range(0.0, 100.0, 0.5, "prefer_slider", "suffix:%") var SneakingSpeed:float = 70.0

#endregion
#region Player Damage
@export_subgroup("Player Damage")
## Use Damage Overrides
## [br] [br]
## This controls the logic behind how player damage ought to be calculated. If this is [code]true[/code], you may freely define how much
## damage each attack does. When this is [code]false[/code], the game calculates how much damage each attack does based on [param BaseAttackDamage] and [param BaseAttackScaling]
## [br] [br]
## [b]Base Value[/b] = [code]true[/code]
@export var UseDamageOverride:bool = true
@export_subgroup("Player Damage/Calculated Damage Envelope")
## @deprecated: Base Attack Damage
## 
## This controls the Base Attack Strength of the Player measured in [code]dmg[/code] (HP)
## Since this affects the scaling of all other attacks the player does, changing this changes all other attacks
## [br]
## Does [b]NOTHING[/b] if game uses free values
## [br] [br]
## [b]Base Value[/b] = [code]1 dmg[/code]
@export_range(0, 50, 1, "or_greater", "prefer_slider", "suffix:dmg") var BaseAttackDamage:int = 1
## @deprecated: Base Attack Scaling
##
## This controls how each different attack scales based on [param BaseAttackDamage]
## Each type attack essentially gets this bonus applied a certain number of times, defined later on
## [br] [br]
## [b]Base Value[/b] = [code]2 dmg[/code]
@export_range(0, 50, 1, "or_greater", "prefer_slider", "suffix:dmg") var BaseAttackScaling:int = 2
@export_subgroup("Player Damage/Damage Overrides")
## Light Attack Damage
## 
## This controls the Base Attack Strength of the Player measured in [code]dmg[/code] (HP)
## Since this affects the scaling of all other attacks the player does, changing this changes all other attacks
## [br]
## Does [b]NOTHING[/b] if game uses free values
## [br] [br]
## [b]Base Value[/b] = [code]1 dmg[/code]
@export_group("Player Damage/Damage Overrides") 
@export_range(0, 50, 1, "or_greater", "suffix:dmg") var LightAttackDamage:int = 1
@export_range(0, 50, 1, "or_greater", "suffix:dmg") var HeavyAttackDamage:int = 2
@export_range(0, 50, 1, "or_greater", "suffix:dmg") var DashAttackDamage:int = 0
@export_range(0, 50, 1, "or_greater", "suffix:dmg") var JumpAttackDamage:int = 0
@export_range(0, 50, 1, "or_greater", "suffix:dmg") var JumpDashAttackDamage:int = 0
@export_range(0, 50, 1, "or_greater", "suffix:dmg") var SpecialAttackDamage:int = 0
#endregion



#endregion

#endregion




## Normal Movement
var TimeSpentAccelerating:Vector2 = Vector2(0, 0) # For how long have the player been accelerating? X = Left, Y = Right
var RawVelocity:Vector2 = Vector2(0, 0)
var AcceleratingDirection:Vector2 = Vector2(0, 0)
var prevInput:int
var ChangeDirectionCharger:float = 1.0

## Dashing Stuff
var IsDashing:int = 0
var DashTimer:float = 0.0

const JUMP_VELOCITY = -400.0

func _ready():
	#region Data that will be pulled from the Main goes here
	
	
	#endregion
	
	pass



func _physics_process(delta):
	#region Gravity
	## Makes sure that the player charact is affected by gravity
	if not is_on_floor():
		self.velocity += get_gravity() * delta #Self will be pulled down if in air
	#endregion
	
	#region Movement
	
	#region Movement Left-Right
	## Not the prettiest shit, but who tf cares
	if Input.is_action_pressed("Left") and not Input.is_action_pressed("Right"):
		AcceleratingDirection = Vector2(1, 0)
	elif Input.is_action_pressed("Right") and not Input.is_action_pressed("Left"):
		AcceleratingDirection = Vector2(0, 1)
	elif Input.is_action_pressed("Right") and Input.is_action_pressed("Left"):
		AcceleratingDirection = Vector2(1, 1)
	else:
		AcceleratingDirection = Vector2(0, 0)
	#endregion
	
	#region Movement Jump
	## You press jump - you jump, simple as.
	if Input.is_action_just_pressed("Jump"):
		if self.is_on_floor(): #...but you have to be on the floor of course
			velocity.y = JumpSpeed
		elif DashResetsJump == 1 and IsDashing: #... or you are dashing, and may do so through dash I-frame jump resets
			velocity.y = JumpSpeed
		#elif DashResetsJump == 2 and IsDashing: #This should ONLY be turned on if we enable powerups
			#velocity.y = JumpSpeed
		else: #... else, you may not jump.
			pass
	
	#endregion
	
	#region Walking Acceleration Calculator
	## When the player presses, say [Left], this will calculate for how long the player has pressed that key
	## up to the TimeToReachMaxSpeed variable, row 28. Based on this, one can calculate how far one is up
	## the track towards max speed. so 0 = 0 speed, and when this is equal to TimeToReachMaxSpeed, then
	## speed would be equal to the maximum player speed.
	if AcceleratingDirection == Vector2(1, 0) and TimeSpentAccelerating.x < TimeToReachMaxSpeed: # Player presses the Left Button
		TimeSpentAccelerating.x += 1 * delta #Counts seconds held.
	if AcceleratingDirection == Vector2(0, 1) and TimeSpentAccelerating.y < TimeToReachMaxSpeed: # Player presses the Right Button
		TimeSpentAccelerating.y += 1 * delta #Counts seconds held.
	#endregion
	
	#endregion
	
	#region Deacceleration Calculator
	## This code exists to handle deacceleration, both when no key is held, only one is, or both are.
	## There are formulated in a Vector2, where X represents the [Left] key, and Y represents the [Right]
	## key.
	##
	## The logic behind this is to create a snappy feel when shuffling around rather than have to constantly be
	## eased in and out if you happen to accidentally release a movement key.
	match AcceleratingDirection:
		Vector2(0, 0): # No key is held, everything decreases fast.
			if TimeSpentAccelerating.x > 0.0:
				TimeSpentAccelerating.x -= (MovSpeedDecayFactor * (NoInputModSpdDecay*0.01)) * delta
			if TimeSpentAccelerating.y > 0.0:
				TimeSpentAccelerating.y -= (MovSpeedDecayFactor * (NoInputModSpdDecay*0.01)) * delta
		Vector2(1, 0): # [Left] is held, only [Right] decays fast, but then more slowly.
			if TimeSpentAccelerating.y > TrailingMovSpdDecayLimit*0.01:
				TimeSpentAccelerating.y -= MovSpeedDecayFactor * delta
			if TimeSpentAccelerating.y <= TrailingMovSpdDecayLimit*0.01 and TimeSpentAccelerating.y > 0.0:
				TimeSpentAccelerating.y += TrailingMovSpeedDecay * delta
		Vector2(0, 1): # [Right] is held, only [Left] decays fast, but then more slowly.
			if TimeSpentAccelerating.x > TrailingMovSpdDecayLimit*0.01:
				TimeSpentAccelerating.x -= MovSpeedDecayFactor * delta
			if TimeSpentAccelerating.x <= TrailingMovSpdDecayLimit*0.01 and TimeSpentAccelerating.x > 0.0:
				TimeSpentAccelerating.x += TrailingMovSpeedDecay * delta
		Vector2(1, 1): # [Left]+[Right] is held, decay to 0.7, and hold there (don't cancel movement).
					   # This is technically equivalent to sneaking and is called such.
					   # Can be disabled in the profiler.
			if PlayerMaySneak:
				TimeSpentAccelerating = Vector2 (SneakingSpeed, SneakingSpeed)
			else:
				if TimeSpentAccelerating.x > 0.0:
					TimeSpentAccelerating.x -= (MovSpeedDecayFactor * (NoInputModSpdDecay*0.01)) * delta * delta
				if TimeSpentAccelerating.y > 0.0:
					TimeSpentAccelerating.y -= (MovSpeedDecayFactor * (NoInputModSpdDecay*0.01)) * delta * delta
			
	#endregion
	
	## Get the Raw Velocity of the player through parsing it through Velocity Calculator
	RawVelocity = VelocityCalculator(TimeSpentAccelerating)
	
	
	print(velocity.x)
	
	## Assignment of Velocity
	velocity.x = PlayerVelocityDresser(RawVelocity, delta) * ((2 * IsDashing) + 1)
	## Moves the body based on the internal velocity vector (Vector2D)
	move_and_slide()



func _input(event):
	if Input.is_action_just_pressed("Dash"):
		IsDashing = 1
	if Input.is_action_just_released("Dash"):
		IsDashing = 0


func PlayAnimation(AnimationType):
	%Anim.animation = AnimationType
	%Anim.play(AnimationType)
	



## Using the velocity gathered from previous calculations, use the velocity and the delta to
## assign appropriate animations, flip the player sprite, and create the slidey deceleration effect 
## when swapping directions
## 
## Move the graphical parts to a separate fuction somewhere, please? This should ONLY dress the velocity
func PlayerVelocityDresser(velo, del):
	match AcceleratingDirection:
		Vector2(0, 0):
			PlayAnimation("idle")
			ChangeDirectionCharger = 1.0
			return (velo.y - velo.x)
		Vector2(1, 0):
			%Anim.scale.x = 0.06
			if is_on_floor():
				PlayAnimation("walking")
			else:
				PlayAnimation("idle")
			prevInput = 0
			ChangeDirectionCharger = 1.0
			return (-velo.x + (velo.y * 0.5))
		Vector2(0, 1):
			%Anim.scale.x = -0.06
			if is_on_floor():
				PlayAnimation("walking")
			else:
				PlayAnimation("idle")
			prevInput = 1
			ChangeDirectionCharger = 1.0
			return velo.y -(velo.x*0.5) 
		Vector2(1, 1):
			PlayAnimation("idle")
			if prevInput == 1 and ChangeDirectionCharger >= 0.0:
				ChangeDirectionCharger -= 0.1 * del
				return (velo.y -(velo.x*0.5))*ChangeDirectionCharger
			if prevInput == 0 and ChangeDirectionCharger >= 0.0:
				ChangeDirectionCharger -= 0.1 * del
				return (-velo.x + (velo.y * 0.5))*ChangeDirectionCharger


##### Tools - DO NOT TOUCH #####

## Converts the time spent holding down a key, into character velocity
func VelocityCalculator(Acceleration:Vector2):
	var rawInput = (Acceleration / TimeToReachMaxSpeed)
	var ProcessedInput = Vector2(EaseInOut(rawInput.x), EaseInOut(rawInput.y)) * BaseMovSpeed
	
	return ProcessedInput

## Ease I-O function that controls the acceleration of the player etc.
func EaseInOut(val:float) -> float: 
	# Normalize the input to the domain of the function
	var x = clamp(val, 0.0, 1.0)
	if x < 0.5:
		return 2.0 * x * x
	else:
		return 1.0 - pow(-2.0 * x + 2.0, 2.0) / 2.0
