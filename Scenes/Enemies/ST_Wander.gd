extends State
class_name Wander

@export var enemy : Enemy_Charger
@onready var rand = RandomNumberGenerator.new()
var wander_speed = 60
var moving : bool 

func Enter():
	wait_time_randomizer()
	$WanderTime.start()
	moving = true
	%BodySprite.play("Move")
	

func Update(_delta: float):
	if moving:
		enemy.velocity = enemy.direction * wander_speed
		if %WallChecker.is_colliding() and $FlipCD.is_stopped() and %WallChecker.get_collider().name != "Player":
			enemy.change_dir()
			$FlipCD.start()
	if %PlayerDetector.get_collider().name == "Player":
		Transitioned.emit(self,"Charge")
	if !moving:
		enemy.velocity = Vector2(0,0)

func wait_time_randomizer(): #randomzies the timers for waiting and wandering
	$IdleTime.wait_time = rand.randf_range(1,3)
	$WanderTime.wait_time = rand.randf_range(3,5)


func _on_idle_time_timeout() -> void:
	$WanderTime.start()
	moving = true
	enemy.change_dir()
	%BodySprite.play("Move")


func _on_wander_time_timeout() -> void:
	wait_time_randomizer()
	$IdleTime.start()
	moving = false
	%BodySprite.pause()
