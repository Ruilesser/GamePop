extends CharacterBody2D


const SPEED = 300.0
const BASE_ANIMATION_SPEED: int = 2
const JUMP_VELOCITY = -400.0
const DECEL_RATE = 15.0
const DICE_ROLL_TIME = 0.15
const DICE_DISPLAY_TIME = 0.55
const SLIDING_SPEED = SPEED + 100

@export var HealthPath: NodePath
@export var StunPath: NodePath

@onready var Health = get_node(HealthPath)
@onready var Stun = get_node(StunPath)

var movement_state: int = Enums.MovementState.IDLE
var attacking_debounce: bool = false
var current_score: int = 0

# Gets random damage between 1 and 6. (Might change to give higher chances with hit streaks i dont know)
func _get_random_damage() -> int:
	return randi_range(1, 6)

# Plays the dice animation.
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
	current_score += 1

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
	if %Stun.is_stunned() or attacking_debounce:
		return
	var damage: int = _get_random_damage()
	call_deferred("_play_dice_animation", damage)
	%Combat.process_attacking(damage)

func _process(_delta):
	_process_movement_meta()
	if Input.is_action_pressed("ui_attack"):
		_process_attacking()

func set_standing_collision(value): # toggle between standing and sliding collision
	$StandingCol.set_disabled(value)
	$SlidingCol.set_disabled(!value)

func _physics_process(delta):
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not %Stun.is_stunned():
		velocity.y = JUMP_VELOCITY

	if (Input.is_action_just_pressed("ui_down") and not %Stun.is_stunned()):
		if ((%AnimatedSprite2D.flip_h)):
			velocity.x = SLIDING_SPEED * -1
		else:
			velocity.x = SLIDING_SPEED

	if Input.is_action_pressed("ui_down") and not %Stun.is_stunned():
		#keep sliding as long as button is held
		#momentum is locked here
		movement_state = Enums.MovementState.SLIDE
		velocity.x = move_toward(velocity.x, 0, DECEL_RATE / 3)

		if (not is_on_floor()):
			# Add the gravity.
			velocity += get_gravity() * delta
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if (collision.get_collider().is_in_group("enemy")):
				print("enemy hit")
		return move_and_slide()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and not %Stun.is_stunned(): # move in the directionsdadwsa
		var hitbox_distance = abs(%Hitbox.position.x - %StandingCol.position.x)
		if direction == 1:
			%AnimatedSprite2D.flip_h = false
			%Hitbox.position.x = %StandingCol.position.x + hitbox_distance
		else:
			%Hitbox.position.x = %StandingCol.position.x - hitbox_distance
			%AnimatedSprite2D.flip_h = true
		#movement_state = SKID
		velocity.x = SPEED * direction
	else: # stop moving
		if (velocity.x == 0):
			movement_state = Enums.MovementState.IDLE
		else:
			movement_state = Enums.MovementState.SKID
			velocity.x = move_toward(velocity.x, 0, DECEL_RATE) # move toward 0 while holding LEFT

	if not is_on_floor():
		movement_state = Enums.MovementState.JUMP
		# Add the gravity.
		velocity += get_gravity() * delta
	else:
		if velocity.x != 0:
			movement_state = Enums.MovementState.RUN
		else:
			movement_state = Enums.MovementState.IDLE

	self.set_meta("MovementState", movement_state)
	move_and_slide()

func get_health_controller():
	return Health

func get_stun_controller():
	return Stun

func get_score() -> int:
	return current_score
