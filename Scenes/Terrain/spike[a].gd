extends Area2D
@export var colour_mask = Global.Colour_States.K

func _ready():
	$Sprite2D.material.set_shader_parameter("colour", Global.colourDict[colour_mask])
	if colour_mask == Global.Colour_States.C:
		set_collision_layer_value(2,true)
		set_collision_mask_value(2,true)
		set_collision_layer_value(3,false)
		set_collision_mask_value(3,false)
		set_collision_layer_value(4,true)
		set_collision_mask_value(4,true)
		set_collision_layer_value(5,true)
		set_collision_mask_value(5,true)
		
		
	if 	colour_mask == Global.Colour_States.Y:
		set_collision_layer_value(2,true)
		set_collision_mask_value(2,true)
		set_collision_layer_value(3,true)
		set_collision_mask_value(3,true)
		set_collision_layer_value(4,false)
		set_collision_mask_value(4,false)
		set_collision_layer_value(5,true)
		set_collision_mask_value(5,true)
		
	if colour_mask == Global.Colour_States.M:
		set_collision_layer_value(2,true)
		set_collision_mask_value(2,true)
		set_collision_layer_value(3,true)
		set_collision_mask_value(3,true)
		set_collision_layer_value(4,true)
		set_collision_mask_value(4,true)
		set_collision_layer_value(5,false)
		set_collision_mask_value(5,false)



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.die()
