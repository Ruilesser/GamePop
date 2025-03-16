extends Node2D
# This assumes that the parent has a AnimatedSprite2D node named "AnimatedSprite2D".

@export var MaxHealth: int = 100
var current_health: int = MaxHealth
@export var hp_bar: NodePath
var hp_bar_script
# Play the hurt animation.
func _ready() -> void:
	if (hp_bar):
		hp_bar_script = get_node(hp_bar)

func _play_hurt_animation():
	var animator = get_parent().get_node("AnimatedSprite2D")
	animator.play("hurt")
	await animator.animation_finished
	animator.play("idle")

# Take damage from the player.
func take_damage(damage: int) -> int:
	current_health = max(0, current_health - damage)
	call_deferred("_play_hurt_animation")
	return current_health
	hp_bar_script.redraw = true

# Heal the player.
func heal(heal_amount: int) -> int:
	current_health = min(MaxHealth, current_health + heal_amount)
	hp_bar_script.redraw = true
	return current_health
	

# Reset health to maximum.
func reset_health() -> void:
	current_health = MaxHealth
	hp_bar_script.redraw = true
	
# Check if the entity is alive.
func is_alive() -> bool:
	return current_health > 0

# Check if the entity is dead.
func is_dead() -> bool:
	return current_health == 0

# Set health to a specific value.
func set_health(value: int) -> void:
	current_health = clamp(value, 0, MaxHealth)
	hp_bar_script.redraw = true
	
