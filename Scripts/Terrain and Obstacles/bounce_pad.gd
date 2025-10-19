extends Area2D

class_name Bounce_Pad

@export var colour_mask = Global.Colour_States.K
@export var bounce_vector:Vector2 = Vector2(0,-400)
@export var bounce_duration:float = 0.2

var player : Player

func _ready():
	$AnimatedSprite2D.material.set_shader_parameter("colour",Global.colourDict[colour_mask])
	
	if colour_mask == Global.Colour_States.K:
		set_collision_layer_value(2,true)
		set_collision_layer_value(3,false)
		set_collision_layer_value(4,false)
		set_collision_layer_value(5,false)

	if colour_mask == Global.Colour_States.C:
		set_collision_layer_value(2,false)
		set_collision_layer_value(3,true)
		set_collision_layer_value(4,false)
		set_collision_layer_value(5,false)
		
	if 	colour_mask == Global.Colour_States.Y:
		set_collision_layer_value(2,false)
		set_collision_layer_value(3,false)
		set_collision_layer_value(4,true)
		set_collision_layer_value(5,false)
		
	if colour_mask == Global.Colour_States.M:
		set_collision_layer_value(2,false)
		set_collision_layer_value(3,false)
		set_collision_layer_value(4,false)
		set_collision_layer_value(5,true)


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Player:
		if body.colour_mask == self.colour_mask:
			print("BOING")
			$AudioStreamPlayer2D.pitch_scale = randf_range(1.2,1.4)
			$AudioStreamPlayer2D.volume_db = randf_range(-15,-14.8)
			$AudioStreamPlayer2D.play(0.0)
			body.GetBounced(bounce_vector,bounce_duration)
			$AnimatedSprite2D.play("Bounce")
		else:
			print("WRONG COLOR")
	
