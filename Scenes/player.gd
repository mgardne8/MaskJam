extends CharacterBody2D



const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const coyote_time_limit = 0.2

var coyote_timer = 0.0

enum color_mask {K,C,Y,M}

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_timer += delta
	else:
		coyote_timer = 0
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (coyote_timer < coyote_time_limit):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
