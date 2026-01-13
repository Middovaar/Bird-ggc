extends CharacterBody2D
@export var speed = 50
@export var health = 10

var chasing: bool
var dir: Vector2
var player: Area2D

func _ready():
	chasing = false
	dir = Vector2.LEFT
	
func _process(delta):
	move(delta)
	
func move(delta):
	if chasing:
		player = Global.player_body
		velocity.x = position.direction_to(player.position) * speed
		dir.x = abs(velocity.x) / velocity.x
	elif not chasing:
		velocity = dir * speed
	move_and_slide() 
	
	if health == 0:
		queue_free()

func _on_enemy_hitbox_area_entered(area):
	if area == Global.player_dmg_zone:
		queue_free()
		
func _on_border_right_area_entered(area):
	print("left")
	dir = Vector2.LEFT
	
func _on_border_left_area_entered(area):
	print("right")
	dir = Vector2.RIGHT
