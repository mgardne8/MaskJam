extends Area2D


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		var player : Player = body
		player.damage_player()	
		if player.is_on_floor():
			print("on floor")	
			player.GetBounced(Vector2(0,-800).rotated(self.global_rotation) + Vector2(0,-20),.05)
		else:
			player.GetBounced(Vector2(0,-400).rotated(self.global_rotation),.05)
