extends StaticBody2D

@export var colour_mask : Array[Global.Colour_States]

func _ready():
	colour_mask.resize(3)
	for colour in colour_mask:
		if colour == null:
			colour_mask[colour] = Global.Colour_States.K 
	$OuterColour.material.set_shader_parameter("colour",Global.colourDict[colour_mask[0]])
	$MiddleColour.material.set_shader_parameter("colour",Global.colourDict[colour_mask[1]])
	$InnerColour.material.set_shader_parameter("colour",Global.colourDict[colour_mask[2]])
	set_collision_layer_value(2,false)
	set_collision_layer_value(3,false)
	set_collision_layer_value(4,false)
	set_collision_layer_value(5,false)
	
	for colour in colour_mask:
	
		if colour == Global.Colour_States.K:
			set_collision_layer_value(2,true)
		if colour == Global.Colour_States.C:
			set_collision_layer_value(3,true)
		if 	colour == Global.Colour_States.Y:
			set_collision_layer_value(4,true)
		if colour == Global.Colour_States.M:
			set_collision_layer_value(5,true)
