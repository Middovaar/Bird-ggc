extends StaticBody2D

# Is the Wall an insta-destroyable, or is does it have HP
@export var WallisFirm:bool = true
# If it has HP - how much HP?
@export var WallHP:int = 3

# The most common velocity (mean)
@export var VelocityTarget:float = 40.0
# The 1-sigma deviation
@export var OneSigmaSize:float = 30.0

# Is the wall destroyed?
@export var WallisDestroyed:bool = false

func _physics_process(delta):
	if WallisDestroyed:
		self.position.y += 300 * delta
		for child in get_children():
			var random_x_vel = generate_positive_normal_velocity(VelocityTarget, OneSigmaSize)
			# Duck-typing: Check what kind of body the child is and apply the velocity.
			# RigidBodies use 'linear_velocity', CharacterBodies use 'velocity'.
			child.position.x += abs(random_x_vel)*0.2
		self.modulate = lerp(self.modulate, Color.TRANSPARENT, 0.1)

func _on_player_attacking(Victim, AtkType, Damage): #Player signal to determine the walld
	if Victim == self:
		if WallisFirm:
			WallHP -= 1
			if WallHP <= 0:
				DestroyWall()
		else:
			DestroyWall()
	else:
		pass

func DestroyWall():
	WallisDestroyed = true
	$WallCollision.queue_free()
	apply_break_velocity_to_children()
	

func apply_break_velocity_to_children():
	await get_tree().create_timer(0.6).timeout
	Exiter()


func generate_positive_normal_velocity(mean: float, deviation: float) -> float:
	var result: float = -1.0
	
	# Keep rolling until we get a number greater than 0. 
	# This ensures we don't accidentally shoot debris backwards or freeze it.
	while result <= 0.0:
		result = randfn(mean, deviation)
		
	return result


func Exiter():
	queue_free()
