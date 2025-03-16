extends TileMapLayer

@export var player: NodePath
var player_node
var redraw : bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_node = get_node(player)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (redraw):
		redraw_hp()
	
func redraw_hp() -> void:
	var bars = ceil(float(player_node.current_health)/float(player_node.MaxHealth)*5)
	print(global_position," ",player_node.global_position)
	var cell_positions = get_used_cells()
	for i in range(bars):
		var position = Vector2i(4,0)
		if (i == 0):
			position = Vector2i(3,0)
		elif(i == 4):
			position = Vector2i(5,0)
				
		set_cell(cell_positions[i],0,position,0)
	if(4-bars != 0):
		for i in range(4,bars-1,-1):
			print(bars)
			var position = Vector2i(1,0)
			if (i == 0):
				position = Vector2i(0,0)
			elif(i == 4):
				position = Vector2i(2,0)
					
			set_cell(cell_positions[i],0,position,0)
