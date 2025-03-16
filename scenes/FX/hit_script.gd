extends Node

@onready var hit_effect_scene = preload("res://scenes/FX/Hit_Effect.tscn")
# When calling, make sure to put hit_position as the one who is taking damage
func spawn_hit_effect(hit_position: Vector2):
	
	# Change node to whatever works
	var hit_effect = hit_effect_scene.instantiate()
	
	# Generate random position
	var random_offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))
	
	hit_effect.global_position = hit_position + random_offset
	
	if hit_effect is GPUParticles2D:
		hit_effect.emitting = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
