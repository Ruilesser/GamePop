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
	button.text = "Rules"
	button.pressed.connect(_button_pressed)

func _button_pressed():
	$"../Button24".pitch_scale = randf_range(0.8, 5)
	$"../Button24".play()
	menu.visible = !menu.visible
	if (on):
		start.disabled = false
		title.show()
		button.position = Vector2(-512,127)
		button.text = "Rules"
	else:
		start.disabled = true
		title.hide()
		button.position = Vector2(-512,227)
		button.text = "Go Back"
	on = !on


func _on_mouse_entered() -> void:
	$"../Button17".pitch_scale = randf_range(0.8, 5)
	$"../Button17".play()


func _on_start_button_pressed() -> void:
	$"../Button24".pitch_scale = randf_range(0.8, 5)
	$"../Button24".play()




func _on_start_button_mouse_entered() -> void:
	$"../Button17".pitch_scale = randf_range(0.8, 5)
	$"../Button17".play()
