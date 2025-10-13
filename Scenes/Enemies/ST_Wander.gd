extends State
class_name Wander

@export var enemy : CharacterBody2D
@onready var rand = RandomNumberGenerator.new()
var moving : bool 

func Enter():
	wait_time_randomizer()
	$IdleTime.start()
	moving = false
	
	

func Update(_delta: float):
	enemy.velocity = Vector2(1,0)


func wait_time_randomizer():
	
	$IdleTime.wait_time = rand.randf_range(1,3)
	$WanderTime.wait_time = rand.randf_range(3,5)


func _on_idle_time_timeout() -> void:
	$WanderTime.start()
	moving = true




func _on_wander_time_timeout() -> void:
	pass # Replace with function body.
