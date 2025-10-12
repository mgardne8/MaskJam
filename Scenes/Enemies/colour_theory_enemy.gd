extends Enemy

@export var colour_mask_2 = Global.Colour_States.K
var visual_colour
var enemy_colours_left = {}
var colour_remaining_count = 2
func READY():
	enemy_colours_left[colour_mask] = Global.colourDict[colour_mask]
	enemy_colours_left[colour_mask_2] = Global.colourDict[colour_mask_2]
	visual_colour = (Global.colourDict[colour_mask] + Global.colourDict[colour_mask_2])/2
	$BaseSprite.material.set_shader_parameter("colour", visual_colour)

func movement(delta):
	velocity = speed*direction

	if not is_on_floor():
		velocity += get_gravity()*mass * delta
	move_and_slide()

func colour_drain(colour_to_drain):
	if colour_remaining_count > 1:
		enemy_colours_left.erase(colour_to_drain)
		visual_colour = visual_colour*2 - Global.colourDict[colour_to_drain]
		$BaseSprite.material.set_shader_parameter("colour", visual_colour)
		colour_remaining_count -= 1
	else:
		die()


func _on_killbox_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.



func _on_bounce_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
			var player : Player = body
			if enemy_colours_left.has(player.colour_mask):
				player.velocity.y = player.JUMP_VELOCITY*1.5
				colour_drain(player.colour_mask)
			else:
				player.die()
	
	
