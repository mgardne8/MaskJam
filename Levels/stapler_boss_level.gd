extends Node

var remover_start_pos = Vector2(0,0)
var Ink_requirement : Array[Global.Colour_States]
var ink_requirement_count = 15
@onready var rand = RandomNumberGenerator.new()

func _ready() -> void:
	Global.minion_count = 0
	for x in ink_requirement_count:
		var ink = randi_range(0,1)
		Ink_requirement.append(ink)
	
	$InkDropPoint.ink_requirements = Ink_requirement
	print($InkDropPoint.ink_requirements)
