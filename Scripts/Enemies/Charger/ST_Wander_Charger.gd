extends State
class_name Wander_Charger

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
	
	enemy.velocity = enemy.direction * wander_speed
	if %WallChecker.is_colliding() and $FlipCD.is_stopped() and %WallChecker.get_collider().name != "Player":
		enemy.change_dir()
		$FlipCD.start()
	if %PlayerDetector.is_colliding():
		if %PlayerDetector.get_collider().name == "Player" and %ChargeCD.is_stopped():
			Transitioned.emit(self,"Charge")


func Exit():
	$WanderTime.stop()

func wait_time_randomizer(): #randomzies the timers for waiting and wandering
	$WanderTime.wait_time = rand.randf_range(3,5)


func _on_wander_time_timeout() -> void:
	wait_time_randomizer()
	enemy.change_dir()
	$WanderTime.start()
