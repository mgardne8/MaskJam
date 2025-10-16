extends State


func Enter():
	%BodySprite.play("Fire")
	%ProtectileSprite.visible = true
	%ProtectileSprite.play("FireProjectile")
	$FireTime.start()

func Exit():
	%ProtectileSprite.pause()
	%ProtectileSprite.visible = false


func _on_fire_time_timeout() -> void:
	Transitioned.emit(self,"Transition-Idle_Stapler")
