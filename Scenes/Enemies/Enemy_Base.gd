extends CharacterBody2D

class_name Enemy


@export var colour_mask = "C"
var speed = 15
var direction = Vector2(-1,0)
var player : Player

func _ready():
	$AnimatedSprite2D.material.set_shader_parameter("colour", Global.colourDict[colour_mask])
	$AnimatedSprite2D.play("Roll")
	
func _physics_process(delta: float) -> void:
	velocity = speed*direction
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var collision = move_and_collide(velocity*delta)
	 	
	if collision:
		var collider = collision.get_collider()
		if collider is Player:
			player = collider
			if player.colour_mask == colour_mask:
				die()
			else:
				player.die()
	
	move_and_slide()
	

func die():
	#death annimation
	queue_free()
