extends CharacterBody2D

class_name Enemy_Charger

@export var facing = 1
var direction = Vector2(1,0)
@onready var rand = RandomNumberGenerator.new()
@export var charge_speed = 150
@export var charge_windup = 1
@export var charge_CD = 4
@export var stun_time = 3
@export var colour_mask = Global.Colour_States.K
@export var mass = 20
var invuln = true

func _ready() -> void:
	if facing == -1:
		change_dir()
	%ChargeCD.wait_time = charge_CD
	#%BodySprite.material.set_shader_parameter("colour", Global.colourDict[colour_mask])

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity()*mass * delta
	move_and_slide()
	if !invuln:
		%BodySprite.material.set_shader_parameter("colour", Global.colourDict[colour_mask])
		
func change_dir():  ##Call this only when we want to flip enemy around (if we call every frame seems to stutter)
	if %EdgeAvoidCD.is_stopped():
		scale.x = -1
		direction.x = -direction.x
		%EdgeAvoidCD.start()

func die():
	Global.gain_ink(colour_mask)
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var player : Player = body
		if player.colour_mask == colour_mask and not invuln:
			player.velocity.y = player.JUMP_VELOCITY*1.5
			player.jump_count = 0
			die()
		else:
			player.damage_player()
			var bouncedir = (player.global_position - %BounceVector.global_position).normalized() * 300
			bouncedir.y = bouncedir.y + -60
			player.GetBounced(bouncedir,0.4)


func _on_colour_flash_delay_timeout() -> void:
	if invuln:
		var colour = rand.randi_range(0,3)
		if colour == 0:
			%BodySprite.material.set_shader_parameter("colour", Global.colourDict[Global.Colour_States.K])
		if colour == 1:
			%BodySprite.material.set_shader_parameter("colour", Global.colourDict[Global.Colour_States.C])
		if colour == 2:
			%BodySprite.material.set_shader_parameter("colour", Global.colourDict[Global.Colour_States.Y])
		if colour == 3:
			%BodySprite.material.set_shader_parameter("colour", Global.colourDict[Global.Colour_States.M])
