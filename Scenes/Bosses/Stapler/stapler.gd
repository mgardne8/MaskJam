extends Area2D


func _ready() -> void:
	$BodySprite.play("Fire")
	$BodySprite/ProtectileSprite.play("FireProjectile")
