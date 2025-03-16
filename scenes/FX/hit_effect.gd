extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = true # Start particle effect
	await get_tree().create_timer(lifetime).timeout
	queue_free() # Destroy after playing
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
