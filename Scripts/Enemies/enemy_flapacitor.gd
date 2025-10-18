extends Enemy


func READY():
	$BaseSprite.play("Move")
	

func movement(delta): ## BASE METHOD TO BE OVERITEN BY SPECIFIC ENEMY
	velocity = speed*direction


	move_and_slide()


func _on_kill_box_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var player : Player = body
		if player.colour_mask == colour_mask:
			die()
		else:
			player.damage_player()
	


func _on_bounce_box_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var player : Player = body
		if player.colour_mask == colour_mask:
			player.velocity.y = player.JUMP_VELOCITY*1.5
			player.jump_count = 0
			die()
		else:
			player.damage_player()
