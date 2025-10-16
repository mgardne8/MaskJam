extends Enemy


func READY():
	$BaseSprite.material.set_shader_parameter("colour", Global.colourDict[colour_mask])
	$BaseSprite.play("Move")	

func _physics_process(delta: float) -> void:
	
	movement(delta)


func movement(delta): ## BASE METHOD TO BE OVERITEN BY SPECIFIC ENEMY
	velocity = speed*direction

	if not is_on_floor():
		velocity += get_gravity()*mass * delta
	move_and_slide()
	if $RayCastWall.is_colliding():
		change_dir()
	if not $RayCastDown.is_colliding():
		change_dir()
	move_and_slide()

	
func die(): ## BASE METHOD TO BE OVERITEN BY SPECIFIC ENEMY
	Global.gain_ink(colour_mask)
	queue_free()

##Killbox area (hitting fromt he side) ##THIS SHOULD BE REMOVED FROM THE BASE SCRIPT
func _on_area_2d_body_entered(body: Node2D) -> void:
		if body is Player:
			var player : Player = body
			if player.colour_mask == colour_mask:
				die()
			else:
				player.damage_player(self)
			

##Speacial killbox if hitting from above to bounce player up ##THIS SHOULD BE REMOVED FROM THE BASE SCRIPT
func _on_bounce_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Player:
			var player : Player = body
			if player.colour_mask == colour_mask:
				player.velocity.y = player.JUMP_VELOCITY*1.5
				player.jump_count = 0
				die()
			else:
				player.damage_player(self)
