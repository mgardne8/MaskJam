extends HBoxContainer

var heart_full = preload("res://Art/Heart_Full.png")
var heart_empty = preload("res://Art/Heart_Empty.png")


func update_health(health:int):
	for i in get_child_count():
		get_child(i).texture = heart_full if health > i else heart_empty
