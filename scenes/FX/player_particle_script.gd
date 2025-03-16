extends Node

@onready var enemy_death_scene = preload("res://scenes/FX/enemy_death_particles.tscn")
# When calling, make sure to put hit_position as the one who is taking damage
func spawn_enemy_death_effect(death_position: Vector2):
	
	# Change node to whatever works
	var enemy_death_effect = enemy_death_scene.instantiate()
	
	# Generate random position
	var random_offset = Vector2(randf_range(-5, 5), randf_range(-5, 5))
	
	enemy_death_effect.global_position = death_position + random_offset
	
	if enemy_death_effect is GPUParticles2D:
		enemy_death_effect.emitting = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
