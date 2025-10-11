extends Camera2D

@export var player : CharacterBody2D

@export var randomStrength: float = 30.0
@export var shakeFade: float = 5.0
var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

func apply_shake():
	shake_strength = randomStrength

func _physics_process(delta: float) -> void:
	# Camera movement and zoom code
	#TODO: update to actually reflect direction player is facing when calculating offset - original script stole from car game
	position = position.lerp(player.global_position + Vector2(-150*(player.velocity.length()/850),0).rotated(player.rotation),6*delta)
	#var zoom_level = lerp(zoom[0],4-(player.velocity.length()/100)/2,1*delta)
	#zoom = Vector2(zoom_level,zoom_level)

func _process(delta: float) -> void:
	# Camera shake forcing
	#if(Input.is_action_just_pressed("shake")):
	#	apply_shake()
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		offset = randomOffset()

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))
