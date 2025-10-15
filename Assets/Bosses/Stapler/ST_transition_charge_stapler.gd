extends State

func Enter():
	%BodySprite.play("TransitionToCharge")
	$TransitionTime.start()



func _on_transition_time_timeout() -> void:
	Transitioned.emit(self,"Charge_Stapler")
