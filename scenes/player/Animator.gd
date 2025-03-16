extends AnimatedSprite2D

const BASE_ANIMATION_SPEED: int = 2

var old_movement_state: int = Enums.MovementState.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Play the animation based on the movement state.
func play_movement_animation(movement_state: int):
	if old_movement_state == movement_state:
		return
	old_movement_state = movement_state
	match movement_state:
		Enums.MovementState.IDLE:
			%AnimatedSprite2D.play("idle")
		Enums.MovementState.RUN:
			%AnimatedSprite2D.play("run")
			%AnimatedSprite2D.speed_scale = BASE_ANIMATION_SPEED
		Enums.MovementState.JUMP:
			%AnimatedSprite2D.play("jump")
		Enums.MovementState.SKID:
			%AnimatedSprite2D.play("idle")
		Enums.MovementState.SLIDE:
			%AnimatedSprite2D.play("slide")
