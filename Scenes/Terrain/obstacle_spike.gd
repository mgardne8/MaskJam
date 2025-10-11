extends Obstacle
class_name Spike

var player : CharacterBody2D

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity*delta)
	if collision:
		var collider = collision.get_collider()
		if collider is Player:
			player = collider
			print("collision player")
			if player.colour_mask != colour_mask:
				print("mask missmatch kill player")
				player.die()
