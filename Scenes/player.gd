extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const JUMP_COYOTE_LIMIT = 0.2
const JUMP_COUNT_MAX = 2
const JUMP_WALL_DURATION = 0.15
const JUMP_WALL_STRENGTH = 50

var direction = 0.0
var jump_coyote_time = 0.0
var jump_count = 0
var jump_wall_time = 0.0
var jump_wall_last_side = null

var colour_mask = Global.Colour_States.K
var current_colour = Global.colourDict[colour_mask]

# TEMPORARY TO BE MOVED LATER
func _physics_process(delta: float) -> void:
		#colour change controls
	if Input.is_action_just_pressed("colour_k"):
		$ColorState.send_event("Change K")
	if Input.is_action_just_pressed("colour_c"):
		$ColorState.send_event("Change C")
	if Input.is_action_just_pressed("colour_y"):
		$ColorState.send_event("Change Y")
	if Input.is_action_just_pressed("colour_m"):
		$ColorState.send_event("Change M")

	current_colour = Vector4(
		lerp(current_colour.x,Global.colourDict[colour_mask].x,5*delta),
		lerp(current_colour.y,Global.colourDict[colour_mask].y,5*delta),
		lerp(current_colour.z,Global.colourDict[colour_mask].z,5*delta),
		1)

	$AnimatedSprite2D.material.set_shader_parameter("colour", current_colour)
	
func die():
	#Todo: Player Die Script
	print("PLAYER DIE")

# Movement Functions
func CalcMovement(delta: float) -> void:
	direction = Input.get_axis("move_left","move_right")

	# WallGrab Gravity Modification Logic
	if not is_on_floor() and velocity.y > 0 and (
		($"RayCast2D-LEFT".is_colliding() and Input.is_action_pressed("move_left"))or 
		($"RayCast2D-RIGHT".is_colliding() and Input.is_action_pressed("move_right"))
	):
		velocity = (get_gravity()*.15) # from += to =
	else:
		velocity.y = max(velocity.y + (get_gravity().y * (delta)),-SPEED)
	
	if direction:
		#velocity.x = lerp(velocity.x,direction*SPEED,3*delta)
		velocity.x = direction*SPEED
	else:
		if is_on_floor():
			#velocity.x = move_toward(velocity.x, 0, SPEED*5*delta)
			velocity.x = 0
		else: # less horizonal friction in the air
			velocity.x = move_toward(velocity.x, 0, SPEED*delta)
	
	# Calculate Cayote timer and zero out y velocity
	if is_on_floor():
		jump_coyote_time = 0
		velocity.y = 0
		jump_wall_last_side = null
	else:
		jump_coyote_time += delta
		if velocity.y > 0:
			$PlayerState.send_event("Fall")
	
	# Calculate if sprite needs to be flipped
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		pass

func CalcJump(delta: float) -> void:
	if not jump_wall_time and Input.is_action_just_pressed("jump") and (
		(is_on_floor() or jump_coyote_time < JUMP_COYOTE_LIMIT) or (jump_count < JUMP_COUNT_MAX)
	):
		$PlayerState.send_event("Jump")
		velocity.y = JUMP_VELOCITY if jump_count == 0 else JUMP_VELOCITY*1.5
		#if not is_on_floor() and jump_count > 0:
		#	velocity.x *= 2

func CalcWallJump(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and (
		($"RayCast2D-LEFT".is_colliding() and jump_wall_last_side != $"RayCast2D-LEFT") or
		($"RayCast2D-RIGHT".is_colliding() and jump_wall_last_side != $"RayCast2D-RIGHT")
	):
		$PlayerState.send_event("Wall Jump")
		velocity.y = JUMP_VELOCITY*2
		jump_wall_time = 0.00001

func CalcWallJumpMove(delta: float) -> void:
	var wj_dir := 1 if jump_wall_last_side == $"RayCast2D-LEFT" else -1
	velocity.x = move_toward(velocity.x, SPEED*wj_dir, JUMP_WALL_STRENGTH)
	velocity.y -= JUMP_WALL_STRENGTH*.5
	
	
# State and Event Processing
##Idle
func _on_idle_state_entered() -> void:
	jump_count = 0
	$AnimatedSprite2D.play("IDLE")

func _on_idle_state_physics_processing(delta: float) -> void:
	CalcMovement(delta)
	CalcJump(delta)
	move_and_slide()
	if direction:
		$PlayerState.send_event("Moved")

##Walk
func _on_walking_state_entered() -> void:
	jump_count = 0
	#TODO: Add Walk Animation
	$AnimatedSprite2D.play("RUN")

func _on_walking_state_physics_processing(delta: float) -> void:
	CalcMovement(delta)
	CalcJump(delta)
	move_and_slide()
	if not direction and velocity.x == 0:
		$PlayerState.send_event("Stopped")

##Jump
func _on_jumping_state_entered() -> void:
	jump_count += 1
	$AnimatedSprite2D.play("JUMP")

func _on_jumping_state_physics_processing(delta: float) -> void:
	CalcMovement(delta)
	CalcWallJump(delta)
	CalcJump(delta)
	move_and_slide()
	if is_on_floor(): #We are no longer jumping, so switch to grounded state
		if direction:
			$PlayerState.send_event("Landed")
		else:
			$PlayerState.send_event("Stopped")

##Fall
func _on_falling_state_entered() -> void:
	#TODO: Add Fall Animation
	$AnimatedSprite2D.play("FALL")

func _on_falling_state_physics_processing(delta: float) -> void:
	CalcMovement(delta)
	CalcWallJump(delta)
	CalcJump(delta)
	move_and_slide()
	if is_on_floor(): #We are no longer jumping, so switch to grounded state
		if direction:
			$PlayerState.send_event("Landed")
		else:
			$PlayerState.send_event("Stopped")

##Wall Jump
func _on_wall_jumping_state_entered() -> void:
	velocity.x = 0
	jump_count = 0 # Reset jump count on wall jump
	jump_wall_last_side = $"RayCast2D-LEFT" if $"RayCast2D-LEFT".is_colliding() else $"RayCast2D-RIGHT"
	
	#TODO: Add WallJump Animation
	$AnimatedSprite2D.play("JUMP")

func _on_wall_jumping_state_physics_processing(delta: float) -> void:
	if jump_wall_time < JUMP_WALL_DURATION:
		jump_wall_time += delta
		CalcMovement(delta)
		CalcWallJumpMove(delta)
		move_and_slide()
	else:
		jump_wall_time = 0.0
		$PlayerState.send_event("WallJumpEnd")
	
	#Recalculate sprite flip as we mess with x momentum after movement
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		pass

# Mask Changes
func _on_k_state_entered() -> void:
	colour_mask = Global.Colour_States.K
	set_collision_layer_value(2,true)
	set_collision_mask_value(2,true)
	set_collision_layer_value(3,false)
	set_collision_mask_value(3,false)
	set_collision_layer_value(4,false)
	set_collision_mask_value(4,false)
	set_collision_layer_value(5,false)
	set_collision_mask_value(5,false)


func _on_c_state_exited() -> void:
	colour_mask = Global.Colour_States.C
	set_collision_layer_value(2,false)
	set_collision_mask_value(2,false)
	set_collision_layer_value(3,true)
	set_collision_mask_value(3,true)
	set_collision_layer_value(4,false)
	set_collision_mask_value(4,false)
	set_collision_layer_value(5,false)
	set_collision_mask_value(5,false)


func _on_y_state_entered() -> void:
	colour_mask = Global.Colour_States.Y
	set_collision_layer_value(2,false)
	set_collision_mask_value(2,false)
	set_collision_layer_value(3,false)
	set_collision_mask_value(3,false)
	set_collision_layer_value(4,true)
	set_collision_mask_value(4,true)
	set_collision_layer_value(5,false)
	set_collision_mask_value(5,false)


func _on_m_state_entered() -> void:
	colour_mask = Global.Colour_States.M
	set_collision_layer_value(2,false)
	set_collision_mask_value(2,false)
	set_collision_layer_value(3,false)
	set_collision_mask_value(3,false)
	set_collision_layer_value(4,false)
	set_collision_mask_value(4,false)
	set_collision_layer_value(5,true)
	set_collision_mask_value(5,true)
