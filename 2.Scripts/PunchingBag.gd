extends Area2D

var DamageTaken:int = 0
const Display:String = "Damage: "
var vibrate 

@export_range (1, 20, 1, "or_greater", "suffix:HP") var MaxHP:int = 12
@export_range (1, 20, 1, "or_greater", "suffix:HP") var BossHP:int = 12
@export_range (1, 20, 1, "or_greater", "suffix:HP") var PunchingBagHP:int = 6

@export var Iwannabetheguy:bool
@export_enum("Enemy", "Boss", "Wall") var Type:String
var Walkingleft:bool = false

var Jump:bool = false
var Jumpheight:float = 0.0

var origoposition:Vector2

@export_range(1, 40, 1, "or_greater", "suffix:HP") var WallHP:int = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	origoposition = $Sprite.position
	if Iwannabetheguy:
		Walkies()

func _process(delta):
	if Iwannabetheguy:
		if Walkingleft:
			position.x += 12.0 * delta *10
		else:
			position.x -= 12.0 * delta *10
		if Jump:
			position.y = clampf(position.y+Jumpheight, -146.0, 1000)
			
		Jumpheight = clampf(Jumpheight-gravity, 0.0, 60.0)
		
	
	
	
	if vibrate and Type != "Wall":
		$Sprite.position.x += randi() % 4
		$Sprite.position.y -= randi() % 4
		$Sprite.position.x -= randi() % 4
		$Sprite.position.y += randi() % 4
		if randi()%6 == 0:
			$Sprite.position = origoposition
		
	if vibrate and Type == "Wall":
		$Sprite.position.x += randi() % 4
		$Sprite.position.y -= randi() % 4
		$Sprite.position.x -= randi() % 4
		$Sprite.position.y += randi() % 4
		if randi()%6 == 0:
			$Sprite.position = origoposition


func _on_player_attacking(Victim, AtkType, Damage):
	if self == Victim and Type == "Enemy":
		match AtkType:
			"Light":
				DamageTaken += Damage
				if DamageTaken >= PunchingBagHP:
					self.queue_free()
			"Heavy":
				DamageTaken += Damage
				if DamageTaken >= PunchingBagHP:
					self.queue_free()
		vibrate = true
		await get_tree().create_timer(0.2).timeout
		vibrate = false
		
		$DamageDisplay.text = Display+str(DamageTaken)
	
	if self == Victim and Type == "Wall":
		WallHP -= Damage
		vibrate = true
		await get_tree().create_timer(0.2).timeout
		vibrate = false
		print(WallHP)
		if WallHP < 1:
			#ejectparticles()
			#await particles
			self.queue_free()
	
	if self == Victim and Type == "Boss":
		match AtkType:
			"Light":
				BossHP = clampi(BossHP-Damage, 0, 1000)
				if randi()%20 < 7:
					%Player.CurrentHP -= 5
			"Heavy":
				BossHP = clampi(BossHP-Damage, 0, 1000)
				if randi()%20 < 7:
					%Player.CurrentHP -= 5
		vibrate = true
		await get_tree().create_timer(0.2).timeout
		vibrate = false
		if BossHP == 0:
			self.queue_free()


func Walkies():
	$Sprite.set_flip_h(true)
	Walkingleft = true
	await get_tree().create_timer(3.0).timeout
	$Sprite.set_flip_h(false)
	Walkingleft = false
	await get_tree().create_timer(3.0).timeout
	if randi()%20 > 4:
		Jump = true
		Jumpheight = 40.0
	Jump = false
	Walkies()
