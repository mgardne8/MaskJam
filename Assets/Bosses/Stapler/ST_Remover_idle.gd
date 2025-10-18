extends State

@export var idle_max = 10
@export var idle_min = 5
var idle_time
@onready var rand = RandomNumberGenerator.new()

func Enter():
	idle_time = rand.randf_range(idle_min,idle_max)
	$IdleTime.wait_time = idle_time
	$IdleTime.start()
	%IdleRemover.play("IDLE")

func Update(_delta: float):
	%Remover.velocity = Vector2.ZERO



func _on_idle_time_timeout() -> void:
	%IdleRemover.play("LeaveFrame")
	Transitioned.emit(self,"Bite")
