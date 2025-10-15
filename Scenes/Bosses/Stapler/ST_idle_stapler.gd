extends State

func Enter():
	%BodySprite.play("Idle")
	%StartCharge.start()


func _on_start_charge_timeout() -> void:
	Transitioned.emit(self,"Transition-Charge_Stapler")
