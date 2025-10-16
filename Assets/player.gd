extends CharacterBody2D
class_name Player

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -500.0
const JUMP_COUNT_MAX: int = 2
const JUMP_WALL_DURATION: float = 0.15
const JUMP_WALL_STRENGTH: float = 50

var direction: float = 0.0
var jump_count: int = 0
var jump_wall_time: float = 0.0
var jump_wall_last_side: RayCast2D = null

var colour_mask: int = Global.Colour_States.K
var current_colour: Vector4 = Global.colourDict[colour_mask]

var bounce_vector: Vector2 = Vector2(0,0)
var bounce_duration: float = 0.0
var bounce_timer: float = 0.0


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

func set_layers(layerDict: Dictionary) -> void:
	for layer in layerDict.keys():
		set_collision_layer_value(layer,layerDict[layer])
		set_collision_mask_value(layer,layerDict[layer])

func damage_player(object : Node2D):
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
	
	velocity.x = direction*SPEED if direction else 0.0
	if is_on_floor():
		velocity.y = 0
		jump_wall_last_side = null
	else:
		if velocity.y > 0:
			$PlayerState.send_event("Fall")
	
	# Calculate if sprite needs to be flipped
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true

func CalcJump(delta: float) -> void:
	if not jump_wall_time and Input.is_action_just_pressed("jump") and (jump_count < JUMP_COUNT_MAX):
		$PlayerState.send_event("Jump")
		velocity.y = JUMP_VELOCITY if jump_count == 0 else JUMP_VELOCITY*1.5

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
	# velocity.x = move_toward(velocity.x, SPEED*wj_dir, JUMP_WALL_STRENGTH)
	velocity.x = SPEED*wj_dir
	velocity.y -= JUMP_WALL_STRENGTH*.5
	
func GetBounced(direction: Vector2, duration: float) -> void:
	bounce_vector = direction
	bounce_duration = duration
	$PlayerState.send_event("Bounce")
	
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

	# This is fucked
	if $"RayCast2D-LEFT".is_colliding() and not is_on_floor():
			$AnimatedSprite2D.play("WALL JUMP")
			$AnimatedSprite2D.flip_h = true
	elif $"RayCast2D-RIGHT".is_colliding() and not is_on_floor():
			$AnimatedSprite2D.play("WALL JUMP")
			$AnimatedSprite2D.flip_h = false
#	else:
#			$PlayerState.send_event("FALL")

##Wall Jump
func _on_wall_jumping_state_entered() -> void:
	velocity.x = 0
	jump_count = 0 # Reset jump count on wall jump
	jump_wall_last_side = $"RayCast2D-LEFT" if $"RayCast2D-LEFT".is_colliding() else $"RayCast2D-RIGHT"
	
	#TODO: Add WallJump Animation
	$AnimatedSprite2D.play("WALL JUMP")

func _on_wall_jumping_state_exited() -> void:
	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h

func _on_wall_jumping_state_physics_processing(delta: float) -> void:
	if jump_wall_time < JUMP_WALL_DURATION:
		jump_wall_time += delta
		CalcMovement(delta)
		CalcWallJumpMove(delta)
		move_and_slide()
	else:
		jump_wall_time = 0.0
		$PlayerState.send_event("WallJumpEnd")

##Bounce
func _on_bounced_state_entered() -> void:
	$AnimatedSprite2D.play("JUMP")
	jump_count = 0 # Reset jump count on bouncepad
	bounce_timer = 0.0

func _on_bounced_state_physics_processing(delta: float) -> void:
	if bounce_timer < bounce_duration:
		bounce_timer += delta
		CalcMovement(delta)
		velocity += bounce_vector
		move_and_slide()
	else:
		$PlayerState.send_event("BounceEnd")
		bounce_timer = 0.0

# Mask Changes
func _on_k_state_entered() -> void:
	colour_mask = Global.Colour_States.K
	set_layers({2:true,3:false,4:false,5:false})

func _on_c_state_entered() -> void:
	colour_mask = Global.Colour_States.C
	set_layers({2:false,3:true,4:false,5:false})

func _on_y_state_entered() -> void:
	colour_mask = Global.Colour_States.Y
	set_layers({2:false,3:false,4:true,5:false})

func _on_m_state_entered() -> void:
	colour_mask = Global.Colour_States.M
	set_layers({2:false,3:false,4:false,5:true})
