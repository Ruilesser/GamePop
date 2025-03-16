extends Node

@onready var combo_scene = preload("res://scenes/FX/combo_text.tscn")

func show_combo(position: Vector2, combo_count: int):
	var combo_instance = combo_scene.instantiate() # instantiate combo
	
	var random_offset = Vector2(randf_range(-10, 10), randf_range(10, 20)) # set random
	
	combo_instance.global_position = position + random_offset # please put player position when you call
	
	combo_instance.set_combo_count(combo_count) # set the combo count text
	
	get_tree().current_scene.add_child(combo_instance) # add it to scene (in the ready, will automatically delete once animation is done)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
