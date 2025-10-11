extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const COYOTE_TIME_LIMIT = 0.2

var coyote_timer = 0.0

#enum colour_mask {K,C,Y,M}
#var current_color = colour_mask.K
var colour_mask = 1

enum player_states {IDLE,RUN,JUMP,FALL}
var  current_state = player_states.IDLE

func _ready() -> void:
	$AnimatedSprite2D.play("IDLE")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_timer += delta
	else:
		coyote_timer = 0
	# jump.
	
	if Input.is_action_just_pressed("colour_k"):
		colour_mask = 0
	
	if Input.is_action_just_pressed("colour_c"):
		colour_mask = 1
	
	if Input.is_action_just_pressed("jump") and (coyote_timer < COYOTE_TIME_LIMIT):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Animation control
	if not is_on_floor():
		if velocity.y < 0:
			current_state = player_states.JUMP
		else:
			current_state = player_states.FALL
	else:
		if direction:
			current_state = player_states.RUN
		else:
			current_state = player_states.IDLE
	

	if $AnimatedSprite2D.animation != player_states.keys()[current_state]:
		$AnimatedSprite2D.play(player_states.keys()[current_state])
	
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		pass

	move_and_slide()
	
func die():
	return
