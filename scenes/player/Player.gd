extends CharacterBody2D


const SPEED = 300.0
const BASE_ANIMATION_SPEED: int = 2
const JUMP_VELOCITY = -400.0
const DECEL_RATE = 15.0
var direction : float
enum {IDLE, RUN, JUMP, SKID, SLIDE, HURT}
const SLIDING_SPEED = SPEED + 50

var current_score = 0

var movement_state: int = IDLE

func _process(_delta):
	current_score += 1
	
	match movement_state:
		IDLE:
			%AnimatedSprite2D.play("idle")
			set_standing_collision(true);
		RUN:
			%AnimatedSprite2D.play("run")
			%AnimatedSprite2D.speed_scale = BASE_ANIMATION_SPEED
			set_standing_collision(true);
		JUMP:
			%AnimatedSprite2D.play("jump")
			set_standing_collision(true);
		SKID:
			%AnimatedSprite2D.play("idle")
			set_standing_collision(true);
		SLIDE:
			%AnimatedSprite2D.play("slide")
			set_standing_collision(false)
		HURT:
			%AnimatedSprite2D.play("hurt")
			set_standing_collision(true);

func set_standing_collision( value ): # toggle between standing and sliding collision
	$StandingCol.set_disabled(value)
	$SlidingCol.set_disabled(!value)

func _physics_process(delta):

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("ui_down"):
		#keep sliding as long as button is held
		#momentum is locked here
		movement_state = SLIDE
		if((%AnimatedSprite2D.flip_h)):
			velocity.x = move_toward(velocity.x,SLIDING_SPEED*-1,DECEL_RATE)
		else:
			velocity.x = move_toward(velocity.x,SLIDING_SPEED, DECEL_RATE)
		
		if(not is_on_floor()):
			# Add the gravity.
			velocity += get_gravity() * delta
			
		move_and_slide()
		return

# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction: #move in the directionsdadwsa
		if direction == 1:
			%AnimatedSprite2D.flip_h = false
		else:
			%AnimatedSprite2D.flip_h = true
		movement_state = RUN
		velocity.x = SPEED * direction
	else:#stop moving
		if(velocity.x == 0):
			movement_state = IDLE
		else:
			movement_state = SKID
			velocity.x = move_toward(velocity.x, 0, DECEL_RATE) #move toward 0 while holding LEFT
				
	if not is_on_floor():
		movement_state = JUMP
		# Add the gravity.
		velocity += get_gravity() * delta

	move_and_slide()
	for i in get_slide_collision_count(): #check if player was hit by enemy
		var collision = get_slide_collision(i)
		if( collision.get_collider().name == "enemynamegoeshere"):
			#todo: deal damage
			movement_state = HURT

func get_score() -> int:
	return current_score
