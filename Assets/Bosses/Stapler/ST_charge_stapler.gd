extends State


func Enter():
	%BodySprite.play("ChargeUp")
	$ChargeTime.start()
	


func _on_charge_time_timeout() -> void:
	Transitioned.emit(self,"Fire_Stapler")
