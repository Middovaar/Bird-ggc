extends CharacterBody2D

var state: float
#0 reset
#0.5 idle
#1 forwards patrol
#1.5 return patrol
#2 alert
#3 engaged

var health = 30
var speed = 60
var direction: Vector2

@onready var player = $"../player"

func _ready():
	state = 0


func _physics_process(frame):
	if state == 0:
		$Timer.start()
		$Timer.wait_time = 6
		state = 0.5
	
	if state == 1:
		position = position.move_toward(Global.klo_patrol_2, frame * speed)
	
	if self.position == Global.klo_patrol_2 and state == 1:
		state = 1.5
		
	if state == 1.5:
		position = position.move_toward(Global.klo_patrol_1, frame * speed)
		
	if self.position == Global.klo_patrol_1 and state == 1.5:
		state = 0
	#
	if state == 2:
		velocity = position.direction_to(player.position) * speed
	
	print(state)
	move_and_slide()

func _on_timer_timeout():
	$Timer.stop()
	state = 1
	
func _on_hitbox_area_entered(area):
	if area == Global.player_dmg_zone:
		print("yeouch !")
	
func _on_alert_area_entered(area):
	if area == Global.player_body:
		velocity.x = 0
		velocity.y = 0
		state = 2

func _on_alert_area_exited(area):
	if area == Global.player_body:
		velocity.x = 0
		velocity.y = 0
		state = 1.5

func _on_engage_area_entered(area):
	if area == Global.player_body:
		velocity.x = 0
		velocity.y = 0
		state = 3
