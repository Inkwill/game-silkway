extends Control

func _ready():
	$TileMap.set_cell(0,0,1)
	for i in range(30):
		for j in range(50):
			$TileMap.update_bitmask_area(Vector2(i,j))

func setup_tile():
	var cells = $TileMap.get_used_cells()
	for cell in cells :
		var index = $TileMap.get_cell(cell.x,cell.y)
