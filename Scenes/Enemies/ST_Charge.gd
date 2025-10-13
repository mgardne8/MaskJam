extends State

class_name Charge

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
	if %WallChecker.get_collider() is not Player:
		Transitioned.emit(self,"Stunned")
	


func Exit():
	%PoofLaunch.pause()
	%PoofLaunch.visible = false

func _on_charge_delay_timeout() -> void:
	%PoofCharging.visible = false
	%PoofCharging.pause()
	#%PoofLaunch. visible = true
	#%PoofLaunch.play("Poof")
	enemy.velocity = direction_hold * enemy.charge_speed
	
