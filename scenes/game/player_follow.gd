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
	if (66>abs(delta_position) and abs(delta_position) >= 50):
		global_position.x += (abs(delta_position) - 66)/30 * sign(player_node.velocity.x)
		print("middle left/right")
	elif (abs(delta_position)>66):
		global_position.x = player_node.global_position.x - 66* sign(player_node.velocity.x)
		print("edge")
	if (player_node.movement_state == 0 and abs(delta_position) >= 33):
		print(player_node.direction)
		global_position.x = move_toward(global_position.x,player_node.global_position.x - 33,2)
		print("not moving")
	
