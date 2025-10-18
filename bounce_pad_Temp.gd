extends "res://Assets/Terrain/bounce_pad.gd"

var lifetime = 3

func _ready():
	$AnimatedSprite2D.material.set_shader_parameter("colour",Global.colourDict[colour_mask])
	$DestoryAfter.wait_time = lifetime
	$DestoryAfter.start()
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


func _on_timer_timeout() -> void:
	queue_free()
