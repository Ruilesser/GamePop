extends AnimatedSprite2D

const BASE_ANIMATION_SPEED: int = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
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