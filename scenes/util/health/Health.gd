extends Node2D
# This assumes that the parent has a AnimatedSprite2D node named "AnimatedSprite2D".

@export var MaxHealth: int = 100
var current_health: int = MaxHealth

# Take damage from the player.
func take_damage(damage: int) -> int:
    current_health = max(0, current_health - damage)
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