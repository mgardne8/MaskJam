extends State

func Enter():
	%BodySprite.play("TransitionToIdle")
	$TransitionTimeTI.start()



func _on_transition_time_timeout() -> void:
	Transitioned.emit(self,"Idle_Stapler")
