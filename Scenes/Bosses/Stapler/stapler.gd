extends Area2D

class_name Stapler 


func _ready() -> void:
	$BodySprite.play("Fire")
	$BodySprite/ProtectileSprite.play("FireProjectile")
