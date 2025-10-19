extends Enemy

@export var wander_distance = 600
@onready var start_pos = self.global_position

func READY():
	$BaseSprite.material.set_shader_parameter("colour", Global.colourDict[colour_mask])
	$BaseSprite.play("Move")
	

func movement(delta): ## BASE METHOD TO BE OVERITEN BY SPECIFIC ENEMY
	velocity = speed*direction
	move_and_slide()



func _on_kill_box_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var player : Player = body
		if player.colour_mask == colour_mask:
			die()
		else:
			player.damage_player()
	


func _on_bounce_box_body_entered(body: Node2D) -> void:
	player_bounce_collision(body,colour_mask,self)
