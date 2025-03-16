extends Label

@onready var player: CharacterBody2D = $"../../Player"

# Called when the node eznters the scene tree for the first time.
func _ready() -> void:
	#start at zero
	var black = Color(0.0, 0.0, 0.0, 1.0)
	set("theme_override_colors/font_color",black)
	#set_text("Score: " + String(current_score) )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(player):
		set_text(("Score: %d" % player.get_score() ))
