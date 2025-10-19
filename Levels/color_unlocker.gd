extends Area2D


func _ready() -> void:
	$"Unlock Text".visible = false
	$Left.visible = false
	$Down.visible = false
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Global.unlocked_c = true
		$"Unlock Text".visible = true
		$Left.visible = true
		$Down.visible = true
