extends CharacterBody2D

func _physics_process(delta: float) -> void:
	move_and_slide()

func playbite():
	$AnimationPlayer.play("Attack")

func get_bouncer_point():
	return $BouncerPoint.global_position


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is Player:
		var player : Player = body
		player.GetBounced(player.position - self.position, 0.5)
		player.damage_player()
