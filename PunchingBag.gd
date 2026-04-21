extends Area2D

var DamageTaken:int = 0
const Display:String = "Damage: "
var vibrate 

@export var Iwannabetheguy:bool
var Walkingleft:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if Iwannabetheguy:
		Walkies()

func _process(delta):
	if Iwannabetheguy:
		if Walkingleft:
			position.x += 12.0 * delta *10
		else:
			position.x -= 12.0 * delta *10
	
	if vibrate:
		self.position.x += randi() % 4
		self.position.y -= randi() % 4
		self.position.x -= randi() % 4
		self.position.y += randi() % 4


func _on_player_attacking(Victim, AtkType, Damage):
	if self == Victim:
		print(Victim)
		match AtkType:
			"Light":
				DamageTaken += Damage
			"Heavy":
				DamageTaken += Damage
		vibrate = true
		await get_tree().create_timer(0.2).timeout
		vibrate = false
		
		$DamageDisplay.text = Display+str(DamageTaken)
	

func Walkies():
	$DegugKloePunchingBag.set_flip_h(true)
	Walkingleft = true
	await get_tree().create_timer(3.0).timeout
	$DegugKloePunchingBag.set_flip_h(false)
	Walkingleft = false
	await get_tree().create_timer(3.0).timeout
	Walkies()
