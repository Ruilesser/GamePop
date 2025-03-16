extends CharacterBody2D


const SPEED = 300.0
const BASE_ANIMATION_SPEED: int = 2
const JUMP_VELOCITY = -400.0
const DECEL_RATE = 15.0
const DICE_ROLL_TIME = 0.15
const DICE_DISPLAY_TIME = 0.55

var movement_state: int = Enums.MovementState.IDLE

var stun_type: int = Enums.StunType.NONE
var stun_flag: int = 0
var stun_time_left: int = 0

var combo_number: int = 0
var attacking_debounce: bool = false
var max_combo: int = 2

# Check if the player is stunned.
func is_stunned():
	return stun_type != Enums.StunType.NONE

# Set the stun type and time.
func set_timed_stun(stun_time: int) -> int:
	stun_type = Enums.StunType.STUN
	self.set_meta("StunType", stun_type)
	stun_time_left = stun_time
	stun_flag += 1
	return stun_flag

func set_attacking_stun():
	stun_type = Enums.StunType.ATTACKING
	self.set_meta("StunType", stun_type)
	var new_flag: int = stun_flag + 1
	stun_flag = new_flag
	return func():
		if stun_flag == new_flag:
			stun_type = Enums.StunType.NONE

func _process_stun_logic():
	# Handle the stun logic.
	if stun_type != Enums.StunType.STUN:
		return
	stun_time_left = max(0, stun_time_left - 1)
	if stun_time_left == 0:
		stun_type = Enums.StunType.NONE
		stun_flag += 1
		self.set_meta("StunType", stun_type)

# Gets random damage between 1 and 6. (Might change to give higher chances with hit streaks i dont know)
func _get_random_damage() -> int:
	return randi_range(1, 6)

func _play_dice_animation(result: int):
	attacking_debounce = true
	%DiceRollAnimator.visible = true
	%DiceRollAnimator.play("roll")
	await get_tree().create_timer(DICE_ROLL_TIME).timeout
	%DiceRollAnimator.play("result")
	%DiceRollAnimator.stop()
	$DiceRollAnimator.frame = result - 1
	await get_tree().create_timer(DICE_DISPLAY_TIME).timeout
	%DiceRollAnimator.visible = false
	attacking_debounce = false

# Process the movement state and animations
func _process_movement_meta():
	match movement_state:
			Enums.MovementState.IDLE:
				set_standing_collision(true);
			Enums.MovementState.RUN:
				set_standing_collision(true);
			Enums.MovementState.JUMP:
				set_standing_collision(true);
			Enums.MovementState.SKID:
				set_standing_collision(true);
			Enums.MovementState.SLIDE:
				set_standing_collision(false)
	%AnimatedSprite2D.play_movement_animation(movement_state)

# Process the attacking logic.
func _process_attacking():
	# Could use a FSM here but I don't want to overcomplicate things.
	if is_stunned() or attacking_debounce:
		return
	var reset_stun = set_attacking_stun()
	%AnimatedSprite2D.play("punch%d" % (combo_number + 1))
	var damage = _get_random_damage()
	call_deferred("_play_dice_animation", damage)
	await %AnimatedSprite2D.animation_finished
	reset_stun.call()
	combo_number = (combo_number + 1) % max_combo
	%AnimatedSprite2D.match_movement_animation_on_state(movement_state)

func _process(_delta):
	_process_movement_meta()
	_process_stun_logic()
	if Input.is_action_pressed("ui_attack"):
		_process_attacking()


func set_standing_collision(value): # toggle between standing and sliding collision
	$StandingCol.set_disabled(value)
	$SlidingCol.set_disabled(!value)

func _physics_process(delta):
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if is_on_floor():
		if velocity.x != 0:
			movement_state = Enums.MovementState.RUN
		else:
			movement_state = Enums.MovementState.IDLE

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction and not is_stunned(): # move in the directionsdadwsa
			if direction == 1:
				%AnimatedSprite2D.flip_h = false
			else:
				%AnimatedSprite2D.flip_h = true
			#movement_state = SKID
			velocity.x = SPEED * direction
		else: # stop moving
			if (velocity.x == 0):
				movement_state = Enums.MovementState.IDLE
			else:
				movement_state = Enums.MovementState.SKID
				velocity.x = move_toward(velocity.x, 0, DECEL_RATE) # move toward 0 while holding LEFT

	else:
		movement_state = Enums.MovementState.JUMP
		# Add the gravity.
		velocity += get_gravity() * delta

	self.set_meta("MovementState", movement_state)
	move_and_slide()
