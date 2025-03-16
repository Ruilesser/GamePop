extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	var next_scene = preload("res://scenes/game/Game.tscn")
	var button = self
	button.pressed.connect(_button_pressed)
	add_child(button)

func _button_pressed():
	get_tree().change_scene_to_file("res://scenes/game/Game.tscn")
	print("Hello world!")
