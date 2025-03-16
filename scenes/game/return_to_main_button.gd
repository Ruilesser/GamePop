extends Button


# Called when the node enters the scene tree for the first time.
var menu
var button
var on
var start
var title
func _ready():
	on = false
	button = self
	menu = get_child(0)
	start = get_child(1)
	title = get_child(2)
	#button.text = "Rules"
	button.pressed.connect(_button_pressed)

func _button_pressed():
	get_tree().change_scene_to_file("res://scenes/game/Start_Menu.tscn")
