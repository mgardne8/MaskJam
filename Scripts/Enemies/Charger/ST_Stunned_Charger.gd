extends State

class_name Stunned_Charger

@export var enemy : Enemy_Charger

func Enter():
	enemy.invuln = false
	%StunStars.visible = true
	%StunStars.play("Stunned")
	$StunTime.wait_time = enemy.stun_time
	$StunTime.start()
	
func Exit():
	enemy.invuln = true

func _on_stun_time_timeout() -> void:
	%StunStars.visible = false
	%StunStars.pause()
	Transitioned.emit(self,"Wander")
