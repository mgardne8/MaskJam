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
	

func _on_charge_delay_timeout() -> void:
	%PoofCharging.visible = false
	%PoofLaunch. visible = true
	%PoofLaunch.play("Poof")
	enemy.velocity = direction_hold * enemy.charge_speed
