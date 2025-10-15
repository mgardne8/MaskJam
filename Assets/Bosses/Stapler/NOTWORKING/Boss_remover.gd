extends StaticBody2D


var player : Player
var direction: Vector2
var target : Vector2
var neutral_pos =  Vector2(-75,-159)
var speed = 3000

func _ready() -> void:
	%AnimatedSprite2D.play("Bite")
	target = neutral_pos
	
func _physics_process(delta: float) -> void:
	pass
	#%StapleHead.apply_force(( %StapleHead.position - target).normalized() * speed)
	#var force = (target - %StapleHead.position)
	#print(force)
	#
	


#
#func attack(target)
#
#func _on_player_detection_body_entered(body: Node2D) -> void:
	#if body is Player:
		#player = body
		#
