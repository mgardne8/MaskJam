extends Enemy


var colour_mask_base = colour_mask
@export var colour_mask_part1 = Global.Colour_States.K
@export var colour_mask_part2 = Global.Colour_States.K

func READY():
	$BaseSprite.material.set_shader_parameter("colour", Global.colourDict[colour_mask_base])
	%Parts1Sprite.material.set_shader_parameter("colour", Global.colourDict[colour_mask_part1])
	%Parts2Sprite.material.set_shader_parameter("colour", Global.colourDict[colour_mask_part2])
func _physics_process(delta: float) -> void:
	
	movement(delta)


func movement(delta):
	velocity = speed*direction

	if not is_on_floor():
		velocity += get_gravity()*mass * delta
	
	if not $RayCastDown.is_colliding():
		change_dir()
	move_and_slide()



func die():
	#death annimation
	queue_free()

##Killbox area (hitting fromt he side)
func _on_killbox_base_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		var player : Player = body
		if player.colour_mask == colour_mask_base:
			die()
		else:
			player.die()


func _on_parts_1_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		var player : Player = body
		if player.colour_mask == colour_mask_part1:
			$Parts1.queue_free()
		else:
			player.die()


func _on_parts_2_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
			var player : Player = body
			if player.colour_mask == colour_mask_part2:
				player.velocity.y = player.JUMP_VELOCITY*1.5
				$Parts2.queue_free()
			else:
				player.die()
