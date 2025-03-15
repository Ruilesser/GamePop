extends CharacterBody2D


const SPEED = 300.0
const BASE_ANIMATION_SPEED: int = 2
const JUMP_VELOCITY = -400.0

enum {IDLE, RUN, JUMP}

var movement_state: int = IDLE

func _process(_delta):
	match movement_state:
		IDLE:
			%AnimatedSprite2D.play("idle")
		RUN:
			%AnimatedSprite2D.play("run")
			%AnimatedSprite2D.speed_scale = BASE_ANIMATION_SPEED
		JUMP:
			print("Jumping!")
			%AnimatedSprite2D.play("jump")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if is_on_floor():
		if velocity.x != 0:
			movement_state = RUN
		else:
			movement_state = IDLE
	else:
		movement_state = JUMP

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction == 1:
			%AnimatedSprite2D.flip_h = false
		else:
			%AnimatedSprite2D.flip_h = true
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
