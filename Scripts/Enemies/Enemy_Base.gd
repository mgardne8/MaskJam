extends CharacterBody2D

class_name Enemy


@export var colour_mask = Global.Colour_States.K
@export var speed = 25
@export var start_dir = -1
var direction : Vector2 
@export var mass = 15 #determines how fast they fall

func _ready():
	direction.x = start_dir
	direction.y = 0
	READY()

	
func _physics_process(delta: float) -> void:
	
	movement(delta)


func movement(delta): ## BASE METHOD TO BE OVERITEN BY SPECIFIC ENEMY
	velocity = speed*direction

	if not is_on_floor():
		velocity += get_gravity()*mass * delta
	move_and_slide()

func READY(): ##EACH ENEMY will override this method to give specific functions needed
	pass

func change_dir ():  ##Call this only when we want to flip enemy around (if we call every frame seems to stutter)
	scale.x = -1
	direction.x = -direction.x

func player_collision(body,mask,object : Node2D):
	if body.name == "Player":
		var player : Player = body
		if player.colour_mask == mask:
			object.queue_free()
		else:
			player.damage_player()

func player_bounce_collision(body,mask, object :Node2D):
	if body.name == "Player":
			var player : Player = body
			if player.colour_mask == mask:
				player.velocity.y = player.JUMP_VELOCITY*1.5
				player.jump_count = 0
				object.queue_free()
			else:
				player.damage_player()

func die(): ## BASE METHOD TO BE OVERITEN BY SPECIFIC ENEMY
	#death annimation
	queue_free()
