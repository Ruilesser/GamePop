extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label/AnimationPlayer.play("Fade Up")
	await $Label/AnimationPlayer.animation_finished
	queue_free()
	
func set_combo_count(combo_count: int):
	$Label.text = "x" + str(combo_count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
