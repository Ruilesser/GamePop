extends Button


# Called when the node enters the scene tree for the first time.
var menu
var button
var on
var start
func _ready():
	on = false
	button = self
	menu = get_child(0)
	start = get_child(1)
	button.text = "Rules"
	button.pressed.connect(_button_pressed)

func _button_pressed():
	menu.visible = !menu.visible
	if (on):
		start.disabled = false
		button.position = Vector2(-47,25)
	else:
		start.disabled = true
		button.position = Vector2(-47,125)
	on = !on
