extends State
class_name Wander_Charger

@export var enemy : Enemy_Charger
@onready var rand = RandomNumberGenerator.new()
var wander_speed = 60

func Enter():
	%ColourFlashDelay.wait_time = 0.3
	wait_time_randomizer()
	$WanderTime.start()
	%BodySprite.play("Move")
	

func Update(_delta: float):
	if not %RayCastDown.is_colliding() and %EdgeAvoidCD.is_stopped():
		enemy.change_dir()
	if %WallChecker.is_colliding() and $FlipCD.is_stopped() and %WallChecker.get_collider().name != "Player":
		print("wall Collision")
		enemy.change_dir()
		$FlipCD.start()
	if %PlayerDetector.is_colliding():
		if %PlayerDetector.get_collider().name == "Player" and %ChargeCD.is_stopped():
			Transitioned.emit(self,"Charge")
	enemy.velocity = enemy.direction * wander_speed
		
func Exit():
	$WanderTime.stop()

func wait_time_randomizer(): #randomzies the timers for waiting and wandering
	$WanderTime.wait_time = rand.randf_range(3,5)


func _on_wander_time_timeout() -> void:
	wait_time_randomizer()
	enemy.change_dir()
	$WanderTime.start()


	
