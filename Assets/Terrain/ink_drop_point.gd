extends Area2D

class_name InkDropPoint

@export var  ink_requirements : Array[Global.Colour_States]
var requirement_met :bool = false
var draining :bool = false

func _ready() -> void:
	print(ink_requirements)

func deposit_ink():
	for requirment in ink_requirements:
		print(requirment)
		print(Global.ink_counts)
		if Global.ink_counts[requirment] > 0:
			Global.ink_counts[requirment] -= 1
			ink_requirements.erase(requirment)
			print(Global.ink_counts)
	if ink_requirements.is_empty():
		print("REQUIREMENT FULLFILLED")
		requirement_met = true


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Player:
		print("draining")
		draining = true
		deposit_ink()
		$DrainCycle.start()
		Global.checkpoint_pos = $SpawnPoint.global_position

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		draining = false
		print("stop draining")
		$DrainCycle.stop()


func _on_drain_cycle_timeout() -> void:
	if draining:
		deposit_ink()
		
