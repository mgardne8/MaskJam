extends Enemy

@export var colour_mask_2 = Global.Colour_States.K
var visual_colour = Vector4(0,0,0,0)
@export var  enemy_colours_left : Array[Global.Colour_States]
var colour_remaining_count : int
func READY():
	colour_remaining_count = enemy_colours_left.size()
	for colour in enemy_colours_left:
		visual_colour = visual_colour + Global.colourDict[colour]
	visual_colour = visual_colour/colour_remaining_count
	$BaseSprite.material.set_shader_parameter("colour", visual_colour)

func movement(delta):
	velocity = speed*direction

	if not is_on_floor():
		velocity += get_gravity()*mass * delta
	move_and_slide()

func colour_drain(colour_to_drain):
	if colour_remaining_count > 1:
		enemy_colours_left.erase(colour_to_drain)
		colour_remaining_count = enemy_colours_left.size()
		print(enemy_colours_left)
		print(visual_colour)
		visual_colour = Vector4(0,0,0,0)
		for colour in enemy_colours_left:
			visual_colour = visual_colour + Global.colourDict[colour]
		visual_colour = visual_colour/colour_remaining_count 
		$BaseSprite.material.set_shader_parameter("colour", visual_colour)
	else:
		die()


func _on_killbox_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.



func _on_bounce_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
			var player : Player = body
			if enemy_colours_left.has(player.colour_mask):
				player.velocity.y = player.JUMP_VELOCITY*1.5 #replace this with a player function (bounce)
				player.jump_count = 0
				colour_drain(player.colour_mask)
			else:
				player.die()
	
	
