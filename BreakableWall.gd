extends StaticBody2D

var DamageTaken:int = 0
const Display:String = "Damage: "
var vibrate 

@export_range (1, 20, 1, "or_greater", "suffix:HP") var MaxHP:int = 12
@export_range (1, 20, 1, "or_greater", "suffix:HP") var BossHP:int = 12

@export_enum("Enemy", "Boss", "Wall") var Type:String
var Walkingleft:bool = false

@export_range(1, 40, 1, "or_greater", "suffix:HP") var WallHP:int = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	
	if vibrate and Type != "Wall":
		$Sprite.position.x += randi() % 4
		$Sprite.position.y -= randi() % 4
		$Sprite.position.x -= randi() % 4
		$Sprite.position.y += randi() % 4
		
	if vibrate and Type == "Wall":
		$Sprite.position.x += randi() % 4
		$Sprite.position.y -= randi() % 4
		$Sprite.position.x -= randi() % 4
		$Sprite.position.y += randi() % 4


func _on_player_attacking(Victim, AtkType, Damage):
	if self == Victim:
		WallHP -= Damage
		vibrate = true
		await get_tree().create_timer(0.2).timeout
		vibrate = false
		print(WallHP)
		if WallHP < 1:
			#ejectparticles()
			#await particles
			self.queue_free()
