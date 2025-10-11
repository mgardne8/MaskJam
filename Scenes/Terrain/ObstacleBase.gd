extends CharacterBody2D
class_name Obstacle

@export var colour_mask = "Y"

func _ready():
	$Sprite2D.material.set_shader_parameter("colour", Global.colourDict[colour_mask])
	if colour_mask == "C":
		set_collision_layer_value(3,true)
		set_collision_layer_value(4,false)
		set_collision_layer_value(5,false)
		
	if 	colour_mask == "Y":
		set_collision_layer_value(3,false)
		set_collision_layer_value(4,true)
		set_collision_layer_value(5,false)
		
	if colour_mask == "M":
		set_collision_layer_value(3,false)
		set_collision_layer_value(4,false)
		set_collision_layer_value(5,true)
