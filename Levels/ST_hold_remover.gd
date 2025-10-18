extends State

var return_to_pos = Vector2.ZERO
var retreat_speed = 2000
var retreating = false
var hold_delay = 3
var bounce_pad_path = preload("res://Assets/Terrain/bounce_pad_temp.tscn")

func Enter():
	return_to_pos = $"../..".remover_start_pos
	retreating = false
	spawn_bouncer()
	%HoldDelay.wait_time = hold_delay
	%ReturnDelay.wait_time = 1.5
	%HoldDelay.start()

func Update(_delta: float):
	if retreating:
		%Remover.velocity =  (return_to_pos - %Remover.position).normalized() * retreat_speed
	

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
	
func spawn_bouncer():
	var bounce_pad = bounce_pad_path.instantiate()
	bounce_pad.global_position = %Remover.get_bouncer_point()
	bounce_pad.scale = Vector2(2.5,2.5)
	bounce_pad.colour_mask = Global.Colour_States.C
	bounce_pad.rotation = %Remover.rotation
	bounce_pad.bounce_vector = Vector2(0,-1000)
	bounce_pad.bounce_duration = 0.6
	self.get_parent().get_parent().add_child(bounce_pad)
