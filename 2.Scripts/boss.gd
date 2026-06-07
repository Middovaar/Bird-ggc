extends CharacterBody2D


## Max HP
## [br] [br]
## Max HP of the Boss
## [br] [br]
## [b]Base Value[/b] = [code]100 HP[/code]
@export_range(1, 250, 1, "or_greater", "suffix:HP") var MaxHP:int = 144
## Current HP
## [br] [br]
## Current HP of the Player
## [br] [br]
## [b]Base Value[/b] = [code]100 HP[/code]
@export_range(1, 250, 1, "or_greater", "suffix:HP") var CurrentHP:int = 144

@export_subgroup("")
@export var Player:Node
@export var Anim:Node
@export var Phase:int = 1
@export_enum("left", "right", "idle") var DirectionInput:String = "idle"

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
@export_category("Damage Envelope")
## Base Damage for Ground Attack
## [br] [br]
## Determines the DMG of Kloë's melee attack (the wing slap).
## [br] [br]
## [b]Base Value[/b] = [code]12HP[/code]
@export_range(0, 100, 1, "or_more", "prefer_slider", "suffix:HP") var WingSlapDMG:int = 15

var vel:float
var Desireposition
@export_category("Kloë's AI")
@export var MayStartThinking:bool = true

var InputKeyPushedDown:float = 0.0
var Direction:int
var NormalizedSpeed:float

var DashSpeed:float = 0.0
var IsDashing:bool = false
var HasDashed:bool = false

var Flyingfactor:float = 1.0
var Superfly:bool = false
var SuperFlySpeed:float = 300.0
var DetectedPlayerinDiveZone:bool = false

var Diving:bool = false
var ChanceToSuperfly:int = 18
var IsNotLookingForThrowable:bool = false


var PlayerBossDistanceDiscrepancy:Vector2

signal AnimationChanger(EmittingAnimation)
signal SuperflyCamera(yn)
signal Hit(Hittype:String, Damage:int)

## Updates the HP Bar of Kloe to reflect Kloe's lowered HP
signal KloeCurrentHP(HP:int)

func _ready():
	Anim.play("idle")

func KloeReactionTime():
	if MayStartThinking: 
		KloeBrain()

func KloeBrain():
	var RandomBias

	RandomBias = randi() % 20
	
	PlayerBossDistanceDiscrepancy =  Player.get_position() - self.position
	
	if is_on_wall() and is_on_floor() and MayStartThinking:
		velocity.y = Jump(null)
		
	if is_on_floor() and MayStartThinking:
		if PlayerBossDistanceDiscrepancy.x < 0.0 - MovementSpaceTolerance:
			DirectionInput = "left"
		if PlayerBossDistanceDiscrepancy.x > 0.0 + MovementSpaceTolerance:
			DirectionInput = "right"
		if abs(PlayerBossDistanceDiscrepancy.x) < MovementSpaceTolerance:
			DirectionInput = "idle"
	
	if not is_on_floor() and Superfly and MayStartThinking:
		if PlayerBossDistanceDiscrepancy.x < 0.0 - MovementSpaceTolerance:
			DirectionInput = "left"
		if PlayerBossDistanceDiscrepancy.x > 0.0 + MovementSpaceTolerance:
			DirectionInput = "right"
		if abs(PlayerBossDistanceDiscrepancy.x) < MovementSpaceTolerance:
			DirectionInput = "idle"
	
	if abs(PlayerBossDistanceDiscrepancy.x) >= DashThresholdTolerance and Direction != 0 and MayStartThinking:
		if HasDashed != true:
			IsDashing = true
			DashSpeed = Dash()
			HasDashed = true
	
	if is_on_floor() and abs(PlayerBossDistanceDiscrepancy.x) < (MovementSpaceTolerance + 300) and MayStartThinking:
		if abs(PlayerBossDistanceDiscrepancy.y) > 110:
			velocity.y = Jump(null) * get_parent().DeathSlowdownFactor
	
	if RandomBias > ChanceToSuperfly and Superfly != true and MayStartThinking:
		Superfly = true
		SuperFlying()
		
	if abs(PlayerBossDistanceDiscrepancy.x) >= DashThresholdTolerance*2.5 and Direction != 0 and Superfly == false and MayStartThinking:
		Superfly = true
		SuperFlying()
		if ShouldIStoneToss():
			IsNotLookingForThrowable = false
		else:
			IsNotLookingForThrowable = true
			
	if MayStartThinking != true:
		DirectionInput = "idle"
		Direction = 0

func ShouldIStoneToss() -> bool:
	return false

func _physics_process(delta):
	print(velocity.y)
	
	#region Gravity
	### Gravity Handler
	if not is_on_floor() and MayStartThinking:
		velocity += get_gravity() * delta * Flyingfactor * get_parent().DeathSlowdownFactor
	#endregion
	
	#region Movement Generator # Simulates a Keypress
	### Simulating a Keypress
	if not Superfly:
		NormalMovementButtonPresser()
	
	### Simulating a Keypress if Superfly is enabled
	if Superfly:
		SuperflyMovementButtonPresser()
	
	# convert InputKeyPushedDown -1 to +1 >> Normalized Speed so we get the Ease I/O
	NormalizedSpeed = EaseInOut(abs(InputKeyPushedDown)/100) #typecast to float, divide by 100
	
	if not Superfly:
		velocity.x = CalculateSpeed(NormalizedSpeed)+DashSpeed*get_parent().DeathSlowdownFactor
	else:
		velocity.x = SuperFlySpeed*Direction*get_parent().DeathSlowdownFactor
	# decay the DashSpeed
	if DashSpeed > 0:
		DashSpeed -= 5
	if DashSpeed < 0:
		DashSpeed += 5
		
	if DashSpeed <= MaxDashSpeed*Direction*0.5:
		IsDashing = false

	
	# Superfly mode
	if Superfly and velocity.y >= 0.0:
		Flyingfactor = 0
		velocity.y = 0.0
	
	if is_on_floor():
		Flyingfactor = 1
	
	#endregion
	
	#region Handle SpriteFlipping
	match DirectionInput: 
		"left":
			Anim.scale.x = 1
			$DiveCollider.scale.x = 1
		"right":
			Anim.scale.x = -1
			$DiveCollider.scale.x = -1
	#endregion
	
	#region Superfly Diving to hit Player
	if Superfly and DetectedPlayerinDiveZone:
		Dive("atk")
		
	#endregion
	
	
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
	Animationassigner("Dash")
	
	var DressedSpeed:float
	DressedSpeed = MaxDashSpeed*Direction
	return DressedSpeed

func Jump(mode):
	if mode != "Superfly":
		Animationassigner("Jump")
		return JumpSpeed * get_parent().DeathSlowdownFactor
	else:
		Animationassigner("Jump")
		return JumpSpeed * 1.5 *get_parent().DeathSlowdownFactor

func SuperFlying():
	velocity.y = Jump("Superfly")
	emit_signal("SuperflyCamera", true)
	Animationassigner("StartFly")

func Dive(mode):
	Diving == true
	match mode:
		"atk":
			position = lerp(self.position, Player.get_position(), 0.08)
			Engine.time_scale = 0.3
			Animationassigner("Dive")
			await get_tree().create_timer(0.5).timeout
			emit_signal("Hit", "Dive", 10)
			Engine.time_scale = 1.0
			Animationassigner("Airstrike")
			CancelSuperfly()
			
		"cancel":
			Flyingfactor = 1.0
			Animationassigner("Airstrike")
			await $Klonim.animation_finished
			CancelSuperfly()
		
		_:pass

func Animationassigner(Special):

	if Special == null:
		if abs(velocity.x) > 1.0 and is_on_floor():
			Anim.play("idle") #replace with walking animation okeh
		if abs(velocity.x) < 1.0 and is_on_floor():
			Anim.play("idle")
		elif not is_on_floor():
			pass
		
	match Special:
		"Jump":
			Anim.play("flystart")
		#"Dash":
			Anim.play("flystart")
		#"DashEnd":
			Anim.play("dashend")
		"StartFly":
			Anim.play("flystart")
		"Fly":
			Anim.play("fly")
		"Dive":
			Anim.play("dive")
		"DoubleFly":
			Anim.play("doublefly")
		"Airstrike":
			Anim.play("airstrike")
		"NormalAtk":
			Anim.play("wingflap")
		null:
			pass
		_: pass
	pass

func NormalMovementButtonPresser():
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

func SuperflyMovementButtonPresser():
	match DirectionInput:
		"right":
			Direction = 1
			InputKeyPushedDown = 99
			SuperFlySpeed = BaseMovSpeed*2
		"left":
			Direction = -1
			InputKeyPushedDown = 99
			SuperFlySpeed = BaseMovSpeed*2
		_:
			Direction = 1
			InputKeyPushedDown = 99
			SuperFlySpeed = BaseMovSpeed*2

func CancelSuperfly():
	Diving = false
	Superfly = false
	Flyingfactor = 1.0
	emit_signal("SuperflyCamera", false)
	ChanceToSuperfly = 21

## Ease I-O function that controls the acceleration of the player etc.
func EaseInOut(val:float) -> float: 
	# Normalize the input to the domain of the function
	var x = clamp(val, 0.0, 1.0)
	if x < 0.5:
		return 2.0 * x * x
	else:
		return 1.0 - pow(-2.0 * x + 2.0, 2.0) / 2.0

func _on_area_2d_area_entered(area): # Basically Kloe's vision. Is the player in Kloe's FOV or nah when diving
	if area == %Player and Superfly:
		DetectedPlayerinDiveZone = true
	else:
		DetectedPlayerinDiveZone = false

func _KloeDashTimerFinishes(): # Kloe Dashtimer
	if ChanceToSuperfly >= 20:
		# insert logic to balance this out a bit
		
		ChanceToSuperfly = 18
	
	
	if abs(PlayerBossDistanceDiscrepancy.y) < 400.0:
		HasDashed = false
	elif abs(PlayerBossDistanceDiscrepancy.x) > 800.0:
		HasDashed = false
	else:
		pass

func _on_anim_finished(): # Kloe's animation controller
	match Anim.animation:
		"flystart":
			if is_on_floor():
				Animationassigner("DashEnd")
			if Superfly:
				Animationassigner("Fly")
		"fly":
			Animationassigner("DoubleFly")
		"doublefly":
			Animationassigner("Fly")
		"dashend":
			Animationassigner(null)
		_:
			Animationassigner(null)
		"airstrike":
			Animationassigner(null)
		"wingflap":
			Animationassigner(null)
	pass

func _on_ground_attack_body_entered(body): # Controls when Kloe ground-swoops
	if body == Player and self.is_on_floor() and IsDashing == false and MayStartThinking:
		Animationassigner("NormalAtk")
		emit_signal("Hit", "Normal", WingSlapDMG)

func _on_super_flytimer_timeout(): #If Kloe has swooped around for too long, Kloe will dive and land
	if Superfly and IsNotLookingForThrowable:
		Dive("cancel")

func _on_player_bossfightis_open(): #Controls when Kloe should you know, start actually thinking propperly
	MayStartThinking = true

func _on_area_dive_collider_body_entered(body): #Kloe sees player in his dive zone collision box? Kloe dives
	if Superfly and IsNotLookingForThrowable:
		Dive("atk")

func _on_dive_collider_body_entered(body): #Depricated.
	pass # Replace with function body.

func _on_player_attacking(Victim, AtkType, Damage): #Applies damage to Kloe when Saffron attacks them
	if Victim == self and CurrentHP >= 0:
		CurrentHP -= Damage
		emit_signal("KloeCurrentHP", CurrentHP)
	elif CurrentHP <= 0:
		
		self.queue_free()
