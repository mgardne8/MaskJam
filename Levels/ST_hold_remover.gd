extends State

var OG_Pos = Vector2(-621.0,-890.0)
var retreat_speed = 2000
var retreating = false
var hold_delay = 3

func Enter():
	retreating = false
	%HoldDelay.wait_time = hold_delay
	%ReturnDelay.wait_time = 1.5
	%HoldDelay.start()

func Update(_delta: float):
	if retreating:
		%Remover.velocity =  (OG_Pos - %Remover.position).normalized() * retreat_speed
	

func Exit():
	retreating = false
	%Remover.rotation = 0

func _on_hold_delay_timeout() -> void:
	print("time on hold end")
	retreating = true
	%ReturnDelay.start()


func _on_return_delay_timeout() -> void:
	%IdleRemover.play("ReturnFrame")
	Transitioned.emit(self,"Idle")
	
