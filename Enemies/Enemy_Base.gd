extends CharacterBody2D

class_name Enemy

var colour_mask = 1
var speed = 1
var direction = Vector2(-1,0)
var player : Player

func ready():
	colour_mask = 1


func _physics_process(delta: float) -> void:
	velocity = speed*direction
	var collision = move_and_collide(velocity*delta)
	 
	if collision:
		var collider = collision.get_collider()
		if collider is Player:
			player = collider
			print("collision player")
			if player.colour_mask == colour_mask:
				print("mask match kill enemy")
			else:
				print("mask missmatch kill player")
		else:
			print("collisioin wall")
	
	move_and_slide()
	
