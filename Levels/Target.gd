extends Sprite2D

@export var Boss : Node2D

func _physics_process(delta: float) -> void:
	position = Boss.target
