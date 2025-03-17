extends CharacterBody2D

@export var HealthPath: NodePath
@export var StunPath: NodePath

@onready var Health = get_node(HealthPath)
@onready var Stun = get_node(StunPath)

@onready var player: CharacterBody2D = $"../Player"

const SPEED = 320

func _ready():
	add_to_group("enemy")
	%AnimatedSprite2D.play("idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if (player and not %Stun.is_stunned()):
		var distance = vec_to_player(player)
		if (distance.length() > 27):
			print(distance.length())
			chase_player(player)
		else:
			velocity.x = 0
			await %Combat.process_attacking(5, "player")


		if (velocity.x == 0):
			%AnimatedSprite2D.play("idle")
		else:
			var hitbox_distance = abs(%Hitbox.position.x - %StandingCol.position.x)
			%AnimatedSprite2D.flip_h = (velocity.x < 0)
			if (velocity.x > 0):
				%Hitbox.position.x = %StandingCol.position.x + hitbox_distance
			else:
				%Hitbox.position.x = %StandingCol.position.x - hitbox_distance
			%AnimatedSprite2D.play("run")
	move_and_slide()

func get_health_controller():
	return Health

func get_stun_controller():
	return Stun

func chase_player(target):
# unit vector going to the player
	var dest = (player.global_position - global_position).normalized()

	# move towards that vector

	velocity.x = dest.x * SPEED
	# todo:

func vec_to_player(target) -> Vector2:
	return (target.global_position - global_position)
