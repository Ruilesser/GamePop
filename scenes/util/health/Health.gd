extends Node2D
# This assumes that the parent has a AnimatedSprite2D node named "AnimatedSprite2D".

@export var MaxHealth: int
var current_health: int = MaxHealth

@export var hp_bar: NodePath
var hp_bar_script

# Play the hurt animation.
func _ready() -> void:
	current_health = MaxHealth
	if (hp_bar):
		hp_bar_script = get_node(hp_bar)

# Take damage from the player.
func take_damage(damage: int) -> int:
	current_health = max(0, current_health - damage)
	hp_bar_script.redraw = true
	print("Health: ", current_health)
	return current_health

# Heal the player.
func heal(heal_amount: int) -> int:
	current_health = min(MaxHealth, current_health + heal_amount)
	return current_health


# Reset health to maximum.
func reset_health() -> void:
	current_health = MaxHealth

# Check if the entity is alive.
func is_alive() -> bool:
	return current_health > 0

# Check if the entity is dead.
func is_dead() -> bool:
	return current_health == 0

# Set health to a specific value.
func set_health(value: int) -> void:
	current_health = clamp(value, 0, MaxHealth)
