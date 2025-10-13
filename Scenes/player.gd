extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const JUMP_COYOTE_LIMIT = 0.2
const JUMP_COUNT_MAX = 2
const JUMP_WALL_DURATION = 0.15
const JUMP_WALL_STRENGTH = 50

var direction = 0.0
var jump_coyote_time = 0.0
var jump_count = 0
var jump_wall_time = 0.0
var jump_wall_last_side = null

func _ready() -> void:
	var colour_mask = Global.Colour_States.K
	set_collision_layer_value(1,true)
	set_collision_mask_value(1,true)
	set_collision_layer_value(2,true)
	set_collision_mask_value(3,false)
	set_collision_mask_value(4,false)
	set_collision_mask_value(5,false)
	$AnimatedSprite2D.material.set_shader_parameter("colour", Global.colourDict[colour_mask])

func die():
	print("PLAYER DIE")

# Movement Functions
func CalcMovement(delta: float) -> void:
	direction = Input.get_axis("move_left","move_right")

	# WallGrab Gravity Modification Logic
	if not is_on_floor() and velocity.y > 0 and (
		($"RayCast2D-LEFT".is_colliding() and Input.is_action_pressed("move_left"))or 
		($"RayCast2D-RIGHT".is_colliding() and Input.is_action_pressed("move_right"))
	):
		velocity += (get_gravity() * delta*.1)
		print('.1 gravity')
	else:
		velocity += get_gravity() * delta
	
	if direction:
		#velocity.x = lerp(velocity.x,direction*SPEED,3*delta)
		velocity.x = direction*SPEED
	else:
		if is_on_floor():
			#velocity.x = move_toward(velocity.x, 0, SPEED*5*delta)
			velocity.x = 0
			print(velocity.x)
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
			$StateChart.send_event("Fall")
	
	# Calculate if sprite needs to be flipped
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		pass

func CalcJump(delta: float) -> void:
	if not jump_wall_time and Input.is_action_just_pressed("jump") and (
		(is_on_floor() or jump_coyote_time < JUMP_COYOTE_LIMIT) or
		(jump_count < JUMP_COUNT_MAX)
	):
		$StateChart.send_event("Jump")
		velocity.y = JUMP_VELOCITY
		if not is_on_floor() and jump_count > 0:
			velocity.x *= 2

func CalcWallJump(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and (
		$"RayCast2D-LEFT".is_colliding() or $"RayCast2D-RIGHT".is_colliding()
	):
		$StateChart.send_event("Wall Jump")
		velocity.y = JUMP_VELOCITY
		jump_wall_time = 0.00001

func CalcWallJumpMove(delta: float) -> void:
	var wj_dir := 1 if jump_wall_last_side == $"RayCast2D-LEFT" else -1
	velocity.x = move_toward(velocity.x, SPEED*wj_dir, JUMP_WALL_STRENGTH)
	
	
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
		$StateChart.send_event("Moved")

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
		$StateChart.send_event("Stopped")

##Jump
func _on_jumping_state_entered() -> void:
	jump_count += 1
	$AnimatedSprite2D.play("JUMP")
	print('JUMP')

func _on_jumping_state_physics_processing(delta: float) -> void:
	CalcMovement(delta)
	CalcWallJump(delta)
	CalcJump(delta)
	move_and_slide()
	if is_on_floor(): #We are no longer jumping, so switch to grounded state
		if direction:
			$StateChart.send_event("Landed")
		else:
			$StateChart.send_event("Stopped")

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
			$StateChart.send_event("Landed")
		else:
			$StateChart.send_event("Stopped")

##Wall Jump
func _on_wall_jumping_state_entered() -> void:
	velocity.x = 0
	jump_count = 0 # Reset jump count on wall jump
	jump_wall_last_side = $"RayCast2D-LEFT" if $"RayCast2D-LEFT".is_colliding() else $"RayCast2D-RIGHT"
	
	#TODO: Add WallJump Animation
	$AnimatedSprite2D.play("JUMP")

func _on_wall_jumping_state_physics_processing(delta: float) -> void:
	if jump_wall_time < JUMP_WALL_DURATION:
		print('wall jumping')
		jump_wall_time += delta
		CalcMovement(delta)
		CalcWallJumpMove(delta)
		move_and_slide()
	else:
		jump_wall_time = 0.0
		$StateChart.send_event("WallJumpEnd")
	pass # Replace with function body.
