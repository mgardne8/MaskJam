extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const COYOTE_TIME_LIMIT = 0.2
const MAX_JUMPS = 1
const WALL_PUSHBACK = 3000 ###Doesnt seem to be working, should be pushing player off the wall

var coyote_timer = 0.0
var is_wall_sliding : bool = false
var jump_count = 0
var colour_mask = Global.Colour_States.K
var current_colour = Global.colourDict[colour_mask]
#enum colour_mask {K,C,Y,M}
#var current_color = colour_mask.K

enum player_states {IDLE,RUN,JUMP,FALL}
var  current_state = player_states.IDLE

func _ready() -> void:
	var colour_mask = Global.Colour_States.K
	set_collision_layer_value(2,true)
	set_collision_mask_value(3,false)
	set_collision_mask_value(4,false)
	set_collision_mask_value(5,false)
	$AnimatedSprite2D.material.set_shader_parameter("colour", Global.colourDict[colour_mask])
	$AnimatedSprite2D.play("IDLE")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_timer += delta
	else:
		coyote_timer = 0
	# jump.
	if Input.is_action_just_pressed("jump"):
		#basic jump
		if coyote_timer < COYOTE_TIME_LIMIT and current_state != player_states.JUMP: 
			velocity.y = JUMP_VELOCITY	
		
		#Double jump
		if (current_state == player_states.JUMP or player_states.FALL) and jump_count < MAX_JUMPS and coyote_timer > COYOTE_TIME_LIMIT:
			velocity.y = JUMP_VELOCITY	
			jump_count += 1
		
		#Wall Jump working except pushback is not pushing back
		if is_on_wall() and Input.is_action_pressed("move_right"):
			velocity.x = -WALL_PUSHBACK
			velocity.y = JUMP_VELOCITY
			jump_count = 0
		if is_on_wall() and Input.is_action_pressed("move_left"):
			velocity.x = WALL_PUSHBACK
			velocity.y = JUMP_VELOCITY
			jump_count = 0
			
	
	if is_on_floor(): #reset jump count if on floor
		jump_count = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	#colour change controls
	if Input.is_action_just_pressed("colour_k"):
		colour_mask = Global.Colour_States.K
		set_collision_layer_value(2,true)
		set_collision_mask_value(2,true)
		set_collision_layer_value(3,false)
		set_collision_mask_value(3,false)
		set_collision_layer_value(4,false)
		set_collision_mask_value(4,false)
		set_collision_layer_value(5,false)
		set_collision_mask_value(5,false)
		
	if Input.is_action_just_pressed("colour_c"):
		colour_mask = Global.Colour_States.C
		set_collision_layer_value(2,false)
		set_collision_mask_value(2,false)
		set_collision_layer_value(3,true)
		set_collision_mask_value(3,true)
		set_collision_layer_value(4,false)
		set_collision_mask_value(4,false)
		set_collision_layer_value(5,false)
		set_collision_mask_value(5,false)
		
	if Input.is_action_just_pressed("colour_y"):
		colour_mask = Global.Colour_States.Y
		set_collision_layer_value(2,false)
		set_collision_mask_value(2,false)
		set_collision_layer_value(3,false)
		set_collision_mask_value(3,false)
		set_collision_layer_value(4,true)
		set_collision_mask_value(4,true)
		set_collision_layer_value(5,false)
		set_collision_mask_value(5,false)
		
	if Input.is_action_just_pressed("colour_m"):
		colour_mask = Global.Colour_States.M
		set_collision_layer_value(2,false)
		set_collision_mask_value(2,false)
		set_collision_layer_value(3,false)
		set_collision_mask_value(3,false)
		set_collision_layer_value(4,false)
		set_collision_mask_value(4,false)
		set_collision_layer_value(5,true)
		set_collision_mask_value(5,true)

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

	#$AnimatedSprite2D.material.set_shader_parameter("colour", Global.colourDict[colour_mask])
	#current_colour. ( Global.colourDict[colour_mask], delta)
	current_colour = Vector4(
	lerp(current_colour.x,Global.colourDict[colour_mask].x,5*delta),
		lerp(current_colour.y,Global.colourDict[colour_mask].y,5*delta),
		lerp(current_colour.z,Global.colourDict[colour_mask].z,5*delta),
		1)
	$AnimatedSprite2D.material.set_shader_parameter("colour", current_colour)
	move_and_slide()



func die():
	print("PLAYER DIE")
