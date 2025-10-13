extends State

class_name Charge_Charger

@export var enemy: Enemy_Charger
var direction_hold 

func Enter():
	$ChargeDelay.wait_time = enemy.charge_windup
	%PoofCharging.visible = true
	$ChargeDelay.start()
	%PoofCharging.play("Poof")
	%BodySprite.play("ChargeWindup")
	direction_hold = enemy.velocity.normalized()
	enemy.velocity = Vector2(0,0)
	

func Update(_delta: float):
	if %WallChecker.is_colliding() and %WallChecker.get_collider().name != "Player": #for now transitioned to stun if hits anythign but a player
		Transitioned.emit(self,"Stunned")
		print("Stunned!")
	if %WallChecker.is_colliding() and %WallChecker.get_collider().name == "Player":
		enemy.change_dir()
		%ChargeCD.start()
		Transitioned.emit(self,"Wander")


func Exit():
	%BodySprite.pause()

func _on_charge_delay_timeout() -> void:
	%PoofCharging.visible = false
	%PoofCharging.pause()
	#%PoofLaunch. visible = true
	#%PoofLaunch.play("Poof")
	enemy.velocity = direction_hold * enemy.charge_speed
	
