extends CharacterBody2D

class_name Enemy

var colour_mask = 1
var speed = 10
var direction = Vector2(-1,0)
var player : Player

func _ready():
	colour_mask = 1
	$AnimatedSprite2D.play("Roll")


func _physics_process(delta: float) -> void:
	velocity = speed*direction
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var collision = move_and_collide(velocity*delta)
	 	
	if collision:
		var collider = collision.get_collider()
		if collider is Player:
			player = collider
			print("collision player")
			if player.colour_mask == colour_mask:
				print("mask match kill enemy")
				die()
			else:
				print("mask missmatch kill player")
				player.die()
		else:
			print("collisioin wall")
	
	move_and_slide()
	

func die():
	#death annimation
	queue_free()
