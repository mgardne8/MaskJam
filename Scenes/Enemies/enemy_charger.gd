extends CharacterBody2D

class_name Enemy_Charger

var direction = Vector2(1,0)
@export var charge_speed = 150
@export var charge_windup = 1

func _physics_process(delta: float) -> void:
	move_and_slide()

func change_dir():  ##Call this only when we want to flip enemy around (if we call every frame seems to stutter)
	scale.x = -1
	direction.x = -direction.x
