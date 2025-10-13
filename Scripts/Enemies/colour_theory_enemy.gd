extends CharacterBody2D

@export var speed = 30
@export var start_dir = -1
var direction : Vector2 
@export var mass = 15
var visual_colour = Vector4(0,0,0,0)
@export var  enemy_colours_left : Array[Global.Colour_States]
var colour_remaining_count : int

func READY():
	colour_remaining_count = enemy_colours_left.size()
	for colour in enemy_colours_left:
		visual_colour = visual_colour + Global.colourDict[colour]
	visual_colour = visual_colour/colour_remaining_count
	$BaseSprite.material.set_shader_parameter("colour", visual_colour)
	$BaseSprite.play("Move")

func _physics_process(delta: float) -> void:
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
		
func die(): ## BASE METHOD TO BE OVERITEN BY SPECIFIC ENEMY
	#death annimation
	queue_free()

func _on_killbox_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
		if body.name == "Player":
			var player : Player = body
			if enemy_colours_left.has(player.colour_mask):
				player.velocity = (player.position - position).normalized() * 400
				player.jump_count = 0
				colour_drain(player.colour_mask)
			else:
				player.die()


	
	
