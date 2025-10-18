extends Area2D


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		var player : Player = body
		player.damage_player()	
		#player.GetBounced(Vector2(randf_range(-50,50),-300).rotated(self.global_rotation_degrees),.1)
