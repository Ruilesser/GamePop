extends TileMapLayer

@export var player: NodePath
var player_node
var redraw : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_node = get_node(player)
	redraw_hp()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(player_node.current_health)
	if (redraw):
		redraw_hp()
	
func redraw_hp() -> void:
	var bars = ceil(player_node.current_health/20)
	var cell_positions = get_used_cells()
	for i in range(bars):
		set_cell(cell_positions[i],0,get_cell_atlas_coords(cell_positions[i])+Vector2i(3,0),0)
