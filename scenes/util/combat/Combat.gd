extends Node2D

@onready var hit_effect_scene = preload("res://scenes/FX/Hit_Effect.tscn")

@export var max_combo = 2
var combo_number = 0

# Attack the enemy
func _attack_enemy(enemy, damage: int):
	enemy.get_health_controller().take_damage(damage)
	call_deferred("_play_hurt_animation", enemy)
	spawn_hit_effect(enemy.global_position)

# Play the hurt animation.
func _play_hurt_animation(enemy):
	var animator = enemy.get_node("AnimatedSprite2D")
	animator.play("hurt")
	await animator.animation_finished
	animator.play("idle")

# When calling, make sure to put hit_position as the one who is taking damage
func spawn_hit_effect(hit_position: Vector2):
	# Change node to whatever works
	var hit_effect = hit_effect_scene.instantiate()

	# Generate random position
	var random_offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))

	hit_effect.global_position = hit_position + random_offset

	if hit_effect is GPUParticles2D:
		hit_effect.emitting = true

	get_tree().current_scene.add_child(hit_effect)


# Get the attack function for the hitbox.
func _get_attack_function(group: String, damage: int):
	var already_detected = []
	for body in %Hitbox.get_overlapping_bodies():
		if body in already_detected or not body.is_in_group(group):
			continue
		already_detected.append(body)
		_attack_enemy(body, damage)
	return func(enemy):
		if enemy in already_detected or not enemy.is_in_group(group):
			return
		already_detected.append(enemy)
		_attack_enemy(enemy, damage)


# Process the attacking logic.
func process_attacking(damage: int):
	# Could use a FSM here but I don't want to overcomplicate things.
	if %Stun.is_stunned():
		return
	var reset_stun = %Stun.set_attacking_stun()
	var attack_function = _get_attack_function("enemy", damage)
	# The entirety of this is cursed please ignore
	%Hitbox.connect("body_entered", attack_function)
	%AnimatedSprite2D.play("punch%d" % (combo_number + 1))
	await %AnimatedSprite2D.animation_finished
	%Hitbox.disconnect("body_entered", attack_function)
	reset_stun.call()
	combo_number = (combo_number + 1) % max_combo
	%AnimatedSprite2D.match_movement_animation_on_state(Enums.MovementState.IDLE)