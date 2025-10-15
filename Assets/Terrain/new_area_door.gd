extends Area2D

@export var drop_point : InkDropPoint
var open : bool = false

func _physics_process(delta: float) -> void:
	if drop_point.requirement_met:
		$DoorOpen.visible = false
		open = true
		


func _on_body_entered(body: Node2D) -> void:
	if body is Player and open:
		Global.next_level()
		
