extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Hud for ink counts 
	%InkCountHud.text = "K = " + str(Global.ink_counts[0]) + "  : C = " + str(Global.ink_counts[1]) + " : Y = " + str(Global.ink_counts[2]) +" : M = " + str(Global.ink_counts[3])
