extends CharacterBody2D

class_name Enemy


@export var colour_mask = Global.Colour_States.K
@export var speed = 25
@export var path = -1
var direction : Vector2
@export var mass = 15 #determines how fast they fall

func _ready():
	direction.x = path
	direction.y = 0
	$AnimatedSprite2D.material.set_shader_parameter("colour", Global.colourDict[colour_mask])
	$AnimatedSprite2D.play("Roll")
	
func _physics_process(delta: float) -> void:
	
	movement(delta)


func movement(delta):
	velocity = speed*direction
	
	if path > 0:
		$AnimatedSprite2D.flip_h = true
	elif path < 0:
		$AnimatedSprite2D.flip_h = false
	else:
		pass
	if not is_on_floor():
		velocity += get_gravity()*mass * delta
	move_and_slide()

func die():
	#death annimation
	queue_free()

##Killbox area (hitting fromt he side)
func _on_area_2d_body_entered(body: Node2D) -> void:
		if body.name == "Player":
			var player : Player = body
			if player.colour_mask == colour_mask:
				die()
			else:
				player.die()
			


func _on_bounce_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
			var player : Player = body
			if player.colour_mask == colour_mask:
				player.velocity.y = player.JUMP_VELOCITY*1.5
				die()
			else:
				player.die()
