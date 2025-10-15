extends Area2D




func _ready() -> void:
	$BodySprite.play("TransitionToCharge")
	#$BodySprite/ProtectileSprite.play("FireProjectile")


func _on_body_sprite_animation_finished() -> void:
	
	print($BodySprite.animation)
	if $BodySprite.animation == "TransitionToCharge":
		$BodySprite.play("ChargeUp")
		
		if $BodySprite.animation == "ChargeUp":
			$BodySprite.play("Fire")
			%ProtectileSprite.visible = true
			%ProtectileSprite.play("FireProjectile")

	print($BodySprite.animation)
	#if $BodySprite.animation == "Fire":
		#$BodySprite.play("TransitionToIdle")
		#%ProtectileSprite.visible = false
		#%ProtectileSprite.pause()
	#
	#if $BodySprite.animation == "TransitionToIdle":
		#$BodySprite.play("Idle")
