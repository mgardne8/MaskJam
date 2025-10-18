extends CharacterBody2D

class_name Enemy_Charger

var direction = Vector2(1,0)
@export var charge_speed = 150
@export var charge_windup = 1
@export var charge_CD = 4
@export var stun_time = 3
@export var colour_mask = Global.Colour_States.K
@export var mass = 20

func _ready() -> void:
	%ChargeCD.wait_time = charge_CD
	%BodySprite.material.set_shader_parameter("colour", Global.colourDict[colour_mask])

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity()*mass * delta
	move_and_slide()

func change_dir():  ##Call this only when we want to flip enemy around (if we call every frame seems to stutter)
	scale.x = -1
	direction.x = -direction.x

func die():
	Global.gain_ink(colour_mask)
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var player : Player = body
		if player.colour_mask == colour_mask:
			player.velocity.y = player.JUMP_VELOCITY*1.5
			player.jump_count = 0
			die()
		else:
			player.damage_player()
