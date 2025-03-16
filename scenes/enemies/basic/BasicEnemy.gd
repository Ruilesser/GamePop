extends CharacterBody2D

@export var HealthPath: NodePath

@onready var Health = get_node(HealthPath)

func _ready():
	add_to_group("enemy")
	%AnimatedSprite2D.play("idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func get_health_controller():
	return Health