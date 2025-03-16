extends AnimatedSprite2D

const BASE_ANIMATION_SPEED: int = 2

var old_movement_state: int = Enums.MovementState.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _update_animation():
	match get_parent().get_meta("MovementState"):
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

func _process(_delta):
	if old_movement_state != get_parent().get_meta("MovementState"):
		old_movement_state = get_parent().get_meta("MovementState")
		_update_animation()
