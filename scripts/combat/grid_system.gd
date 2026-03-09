## GridSystem.gd
## Core grid logic and data management for the 6x8 combat grid.
## Handles coordinate conversion, cell state, and grid queries.
class_name GridSystem
extends RefCounted

# Grid dimensions
const GRID_COLS: int = 6
const GRID_ROWS: int = 8
const TOTAL_CELLS: int = GRID_COLS * GRID_ROWS

# Cell sizing (calculated for 720px width with margins)
const GRID_MARGIN_X: int = 20
const GRID_MARGIN_Y: int = 100  # Space for UI at top/bottom
const CELL_GAP: int = 2

# State
var _cell_size: Vector2 = Vector2.ZERO
var _grid_offset: Vector2 = Vector2.ZERO
var _viewport_size: Vector2 = Vector2.ZERO


## Initialize grid with viewport dimensions
func initialize(viewport_size: Vector2) -> void:
	_viewport_size = viewport_size
	_calculate_cell_size()
	_calculate_grid_offset()


## Calculate cell size to fit grid in viewport
func _calculate_cell_size() -> void:
	# Available space for grid
	var available_width: float = _viewport_size.x - (GRID_MARGIN_X * 2)
	var available_height: float = _viewport_size.y - (GRID_MARGIN_Y * 2)

	# Calculate cell size to fit both dimensions
	var cell_width: float = (available_width - (CELL_GAP * (GRID_COLS - 1))) / GRID_COLS
	var cell_height: float = (available_height - (CELL_GAP * (GRID_ROWS - 1))) / GRID_ROWS

	# Use square cells (minimum of width/height)
	var cell_size: float = min(cell_width, cell_height)
	_cell_size = Vector2(cell_size, cell_size)


## Calculate grid offset to center it in viewport
func _calculate_grid_offset() -> void:
	var grid_pixel_size: Vector2 = get_grid_pixel_size()
	var remaining_width: float = _viewport_size.x - grid_pixel_size.x
	var remaining_height: float = _viewport_size.y - grid_pixel_size.y

	_grid_offset = Vector2(
		remaining_width / 2.0,
		remaining_height / 2.0
	)


## Get the calculated cell size
func get_cell_size() -> Vector2:
	return _cell_size


## Get the grid offset (for centering)
func get_grid_offset() -> Vector2:
	return _grid_offset


## Convert grid coordinates (col, row) to screen position (top-left of cell)
func grid_to_screen(col: int, row: int) -> Vector2:
	return Vector2(
		_grid_offset.x + col * (_cell_size.x + CELL_GAP),
		_grid_offset.y + row * (_cell_size.y + CELL_GAP)
	)


## Convert grid position (Vector2i) to screen position
func grid_to_screenv(pos: Vector2i) -> Vector2:
	return grid_to_screen(pos.x, pos.y)


## Convert screen position to grid coordinates
func screen_to_grid(screen_pos: Vector2) -> Vector2i:
	var local_pos: Vector2 = screen_pos - _grid_offset

	var col: int = int(local_pos.x / (_cell_size.x + CELL_GAP))
	var row: int = int(local_pos.y / (_cell_size.y + CELL_GAP))

	return Vector2i(col, row)


## Check if grid coordinates are valid
func is_valid_cell(col: int, row: int) -> bool:
	return col >= 0 and col < GRID_COLS and row >= 0 and row < GRID_ROWS


## Check if grid position (Vector2i) is valid
func is_valid_cellv(pos: Vector2i) -> bool:
	return is_valid_cell(pos.x, pos.y)


## Get the center position of a cell in screen coordinates
func get_cell_center(col: int, row: int) -> Vector2:
	var top_left: Vector2 = grid_to_screen(col, row)
	return Vector2(
		top_left.x + _cell_size.x / 2.0,
		top_left.y + _cell_size.y / 2.0
	)


## Get the center position of a cell (Vector2i version)
func get_cell_centerv(pos: Vector2i) -> Vector2:
	return get_cell_center(pos.x, pos.y)


## Get distance between two grid cells (Manhattan distance)
func get_manhattan_distance(from: Vector2i, to: Vector2i) -> int:
	return abs(to.x - from.x) + abs(to.y - from.y)


## Get Euclidean distance between two grid cells
func get_euclidean_distance(from: Vector2i, to: Vector2i) -> float:
	var dx: float = float(to.x - from.x)
	var dy: float = float(to.y - from.y)
	return sqrt(dx * dx + dy * dy)


## Get all valid neighboring cells (orthogonal only)
func get_neighbors(col: int, row: int) -> Array[Vector2i]:
	var neighbors: Array[Vector2i] = []

	var directions: Array[Vector2i] = [
		Vector2i(0, -1),  # Up
		Vector2i(1, 0),   # Right
		Vector2i(0, 1),   # Down
		Vector2i(-1, 0)   # Left
	]

	for dir: Vector2i in directions:
		var neighbor: Vector2i = Vector2i(col + dir.x, row + dir.y)
		if is_valid_cellv(neighbor):
			neighbors.append(neighbor)

	return neighbors


## Get all valid neighboring cells including diagonals
func get_neighbors_with_diagonals(col: int, row: int) -> Array[Vector2i]:
	var neighbors: Array[Vector2i] = []

	for dy: int in range(-1, 2):
		for dx: int in range(-1, 2):
			if dx == 0 and dy == 0:
				continue
			var neighbor: Vector2i = Vector2i(col + dx, row + dy)
			if is_valid_cellv(neighbor):
				neighbors.append(neighbor)

	return neighbors


## Get the total grid dimensions in pixels
func get_grid_pixel_size() -> Vector2:
	return Vector2(
		(_cell_size.x * float(GRID_COLS)) + (float(CELL_GAP) * float(GRID_COLS - 1)),
		(_cell_size.y * float(GRID_ROWS)) + (float(CELL_GAP) * float(GRID_ROWS - 1))
	)


## Get cell index from grid coordinates
func get_cell_index(col: int, row: int) -> int:
	return row * GRID_COLS + col


## Get grid coordinates from cell index
func index_to_grid(index: int) -> Vector2i:
	return Vector2i(index % GRID_COLS, index / GRID_COLS)
