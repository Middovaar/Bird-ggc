#init
extends CharacterBody2D
@onready var H_atk_collider = $dmg_zone/H_atk_collider
@onready var L_atk_collider = $dmg_zone/L_atk_collider

#exported values - core stats
@export var speed = 100
@export var jump = -350
@export var dash = 600
@export var LDMG = 3
@export var HDMG = 5

#code specs
var flipped = false
var direction = 0
var animating = false

var dash_up = true
var dash_CD = 0.5

var atk_up = true
var atk_CD = 0.7
var attacking = false
var atk_charge_goal = 0.7
var atk_charge_now = 0

func _ready():
	Global.player_body = self
	Global.player_dmg_zone = $dmg_zone
	$TMP_sprite.animation = "idle"
	H_atk_collider.set_disabled(true)
	L_atk_collider.set_disabled(true)

func player_animation_finished(): 
	if $TMP_sprite.animation == "dash":
		$TMP_sprite.animation = "idle"
		velocity.x = 0
		animating = false
		get_tree().create_timer(dash_CD).timeout.connect(func(): dash_up = true)
		
	elif $TMP_sprite.animation == "light_atk":
		$TMP_sprite.animation = "idle"
		attacking = false
		animating = false
		L_atk_collider.set_disabled(true)
		get_tree().create_timer(atk_CD).timeout.connect(func(): atk_up = true)
	
	elif $TMP_sprite.animation == "heavy_atk":
		$TMP_sprite.animation = "idle"
		attacking = false
		animating = false
		H_atk_collider.set_disabled(true)
		get_tree().create_timer(atk_CD).timeout.connect(func(): atk_up = true)
			
func _physics_process(delta):	
#more init
	Global.player_dmg_zone = $dmg_zone
	
	
#make player fall
	if not is_on_floor() and not attacking:
		velocity += get_gravity() * delta
		
#jump
	if Input.is_action_just_pressed("jump") and is_on_floor() and not animating:
		velocity.y = jump

#move side to side
#direction returns -1 or +1 depending on first or second action, and null if none are pressed
	direction = Input.get_axis("move_left", "move_right")
	if direction and not animating:
		velocity.x = direction * speed
	if not direction and not animating:
		velocity.x = 0

#flip the sprite
	if Input.is_action_just_pressed("move_left") and not animating:
		if not flipped:
			scale.x *= -1
			flipped = true
	elif Input.is_action_just_pressed("move_right") and not animating:
		if flipped:
			scale.x *= -1
			flipped = false

#dash
	if Input.is_action_just_pressed("dash") and dash_up and not animating:
		animating = true
		dash_up = false
		$TMP_sprite.play("dash")
		if flipped:
			velocity.x = -dash
		else:
			velocity.x = dash

#atk code, figure out if it's pressed or held, heavy attack first:
	if Input.is_action_just_released("attack") and atk_charge_now >= atk_charge_goal and atk_up:
		velocity.x = 0
		velocity.y = 0
		atk_up = false
		attacking = true
		animating = true
		$TMP_sprite.play("heavy_atk")
		H_atk_collider.set_disabled(false)
		
#then light attack:
	elif Input.is_action_just_released("attack") and atk_charge_now <= atk_charge_goal and atk_up:
		velocity.x = 0
		velocity.y = 0
		atk_up = false
		attacking = true
		animating = true
		$TMP_sprite.play("light_atk")
		L_atk_collider.set_disabled(false)
		
#track heavy_atk charge	(delta increments by ~.3 per tick) if not released (check elif)
	if Input.is_action_pressed("attack"):
		atk_charge_now += delta
	else:
		atk_charge_now = 0
		
	move_and_slide()

func detect_hit(ray, tmp, dmg):
	if tmp.is_in_group("enemy"):
		print("hit")
		ray.add_exception(tmp)
		tmp.health -= dmg
		ray.force_raycast_update()
		detect_hit(ray, tmp, dmg)

		
