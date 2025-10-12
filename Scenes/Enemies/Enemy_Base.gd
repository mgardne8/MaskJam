extends CharacterBody2D

class_name Enemy


@export var colour_mask = Global.Colour_States.K
var speed = 25
var direction = Vector2(-1,0)
@export var mass = 15 #determines how fast they fall

func _ready():
	$AnimatedSprite2D.material.set_shader_parameter("colour", Global.colourDict[colour_mask])
	$AnimatedSprite2D.play("Roll")
	
func _physics_process(delta: float) -> void:
	
	movement(delta)


func movement(delta):
	velocity = speed*direction
	
	if not is_on_floor():
		velocity += get_gravity()*mass * delta
	move_and_slide()

func die():
	#death annimation
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
		if body.name == "Player":
			var player : Player = body
			if player.colour_mask == colour_mask:
				die()
			else:
				player.die()
			
