extends Enemy


@export var colour_mask_part1 = Global.Colour_States.K
@onready var rand = RandomNumberGenerator.new()

func READY():
	var colour = rand.randi_range(0,1)
	if colour == 0:
		colour_mask = Global.Colour_States.K
		colour_mask_part1 = Global.Colour_States.C
	else:
		colour_mask = Global.Colour_States.C
		colour_mask_part1 = Global.Colour_States.K
	$BaseSprite.material.set_shader_parameter("colour", Global.colourDict[colour_mask])
	%Part1Sprite.material.set_shader_parameter("colour", Global.colourDict[colour_mask_part1])
func _physics_process(delta: float) -> void:
	
	movement(delta)


func movement(delta):
	velocity = speed*direction

	if not is_on_floor():
		velocity += get_gravity()*mass * delta
	
	if $RayCastWall.is_colliding() and $RayCastWall.get_collider() is not Player:
		change_dir()
	
	if not $RayCastDown.is_colliding():
		change_dir()
	move_and_slide()


func _on_killbox_body_entered(body: Node2D) -> void:
	player_collision(body,colour_mask,self)
	if body is Player:
		if body.colour_mask == colour_mask and $CollisionCD.is_stopped():
			Global.minion_count -= 1
			$CollisionCD.start()
	print(Global.minion_count)
func _on_bounce_area_body_entered(body: Node2D) -> void:
	player_bounce_collision(body,colour_mask,self)
	if body is Player:
		if body.colour_mask == colour_mask and $CollisionCD.is_stopped():
			Global.minion_count -= 1
			$CollisionCD.start()
	print(Global.minion_count)

func _on_part_1_bounce_area_body_entered(body: Node2D) -> void:
	player_bounce_collision(body,colour_mask_part1,$Part1)
	print(Global.minion_count)

func _on_part_1_body_entered(body: Node2D) -> void:
	player_collision(body,colour_mask_part1,$Part1)
	print(Global.minion_count)
