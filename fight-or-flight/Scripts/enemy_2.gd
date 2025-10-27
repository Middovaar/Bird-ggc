extends CharacterBody2D

var dir: Vector2
var chasing: bool
var player: CharacterBody2D

@export var speed = 30

func _ready():
	chasing = false
	
func _process(delta):
	move(delta)
	
func move(delta):
	if chasing:
		player = Global.player_body
		velocity = position.direction_to(player.position) * speed
		dir.x = abs(velocity.x) / velocity.x
	elif not chasing:
		velocity += dir * speed * delta
	move_and_slide() 
	
func _on_timer_timeout():
	$Timer.wait_time = choose([0.25, 0.5, 0.75])
	if not chasing:
		dir = choose([Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN])


func choose(array):
	array.shuffle() 
	return array.front()

func _on_hitbox_area_entered(area):
	if area == Global.player_dmg_zone:
		queue_free()
