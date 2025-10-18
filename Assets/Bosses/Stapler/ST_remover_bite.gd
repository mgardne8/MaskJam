extends State
@export var speed = 1500
@export var delay_max = 2
@export var delay_min = 2
var delay_time
var target = Vector2(0,0)
var direction = Vector2(0,0) 
@onready var rand = RandomNumberGenerator.new()
var attacking = false

func Enter():
	attacking = false
	delay_time = rand.randf_range(delay_min,delay_max)
	$AttackDelay.wait_time = delay_time
	$AttackDelay.start()
	
func Update(_delta: float):
	if attacking: 
		%Remover.velocity = direction*speed
	else:
		%Remover.velocity = Vector2(0,0)
	if abs(%Remover.global_position.x - target.x) and abs(%Remover.global_position.y - target.y) < 30:
		print("close enough")
		%Remover.velocity = Vector2(0,0)
		attacking = false
		Transitioned.emit(self,"Hold")

func _on_attack_delay_timeout() -> void:
	attacking = true
	%Remover.playbite()
	target = %Player.global_position
	direction = (%Player.global_position - %Remover.global_position).normalized()
	%Remover.rotate(direction.angle())
