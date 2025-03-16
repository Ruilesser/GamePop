extends Node2D

@export var player : NodePath
var player_node
var follow
var hard_follow
var player_script

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (player):
		player_node = get_node(player)
	var delta_position = global_position.x -player_node.global_position.x
	print(player_node.movement_state)
	if (300>=abs(delta_position) and abs(delta_position) >= 150):
		global_position.x -= (delta_position + 300)/30
	elif (abs(delta_position)>300):
		global_position.x = player_node.global_position.x - 300
	if (player_node.movement_state == 3):
		print("yooo")
		global_position.x -= (delta_position + 100)/30
		
	
