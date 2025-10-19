extends MarginContainer



func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_type():
		get_tree().change_scene_to_file('res://Levels/Lev1.tscn')
		print('changed')
