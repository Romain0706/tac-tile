## GridRenderer.gd
## Visual rendering of the 6x8 combat grid.
## Uses _draw() for efficient rendering with 60 FPS target.
extends Node2D

# Signals
signal cell_clicked(grid_position: Vector2i)
signal cell_hovered(grid_position: Vector2i)

# Constants
const GRID_LINE_COLOR: Color = Color(0.4, 0.4, 0.5, 0.8)
const GRID_LINE_WIDTH: float = 1.0
const GRID_BACKGROUND_COLOR: Color = Color(0.1, 0.1, 0.15, 0.6)

# Dependencies (GridSystem is RefCounted, cannot be @export)
var grid_system: GridSystem = null

# State
var _cells: Array[GridCell] = []
var _hovered_cell: Vector2i = Vector2i(-1, -1)


func _ready() -> void:
	_initialize_grid_system()
	_initialize_cells()


func _draw() -> void:
	if grid_system == null:
		return

	_draw_background()
	_draw_grid_lines()
	_draw_cell_highlights()


## Initialize grid system with viewport size
func _initialize_grid_system() -> void:
	if grid_system == null:
		grid_system = GridSystem.new()

	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	grid_system.initialize(viewport_size)

	# Center the grid
	position = grid_system.get_grid_offset()


## Initialize all grid cells
func _initialize_cells() -> void:
	_cells.clear()

	for row: int in GridSystem.GRID_ROWS:
		for col: int in GridSystem.GRID_COLS:
			var cell := GridCell.create(col, row)
			_cells.append(cell)


## Draw the grid background
func _draw_background() -> void:
	var grid_size: Vector2 = grid_system.get_grid_pixel_size()
	var rect: Rect2 = Rect2(Vector2.ZERO, grid_size)
	draw_rect(rect, GRID_BACKGROUND_COLOR)


## Draw grid lines
func _draw_grid_lines() -> void:
	var cell_size: Vector2 = grid_system.get_cell_size()
	var grid_size: Vector2 = grid_system.get_grid_pixel_size()

	# Draw vertical lines
	for col: int in range(GridSystem.GRID_COLS + 1):
		var x: float = col * (cell_size.x + GridSystem.CELL_GAP)
		var from: Vector2 = Vector2(x, 0)
		var to: Vector2 = Vector2(x, grid_size.y)
		draw_line(from, to, GRID_LINE_COLOR, GRID_LINE_WIDTH)

	# Draw horizontal lines
	for row: int in range(GridSystem.GRID_ROWS + 1):
		var y: float = row * (cell_size.y + GridSystem.CELL_GAP)
		var from: Vector2 = Vector2(0, y)
		var to: Vector2 = Vector2(grid_size.x, y)
		draw_line(from, to, GRID_LINE_COLOR, GRID_LINE_WIDTH)


## Draw cell highlights based on state
func _draw_cell_highlights() -> void:
	var cell_size: Vector2 = grid_system.get_cell_size()

	for cell: GridCell in _cells:
		if cell.state == GridCell.CellState.NORMAL:
			continue

		var color: Color = cell.get_state_color()
		var pos: Vector2 = grid_system.grid_to_screen(cell.grid_position.x, cell.grid_position.y)
		var rect: Rect2 = Rect2(pos, cell_size)
		draw_rect(rect, color)


## Get cell at grid position
func get_cell(col: int, row: int) -> GridCell:
	var index: int = row * GridSystem.GRID_COLS + col
	if index >= 0 and index < _cells.size():
		return _cells[index]
	return null


## Get cell at grid position (Vector2i version)
func get_cellv(pos: Vector2i) -> GridCell:
	return get_cell(pos.x, pos.y)


## Set cell state for visual feedback
func set_cell_state(col: int, row: int, state: GridCell.CellState) -> void:
	var cell: GridCell = get_cell(col, row)
	if cell:
		cell.set_state(state)
		queue_redraw()


## Reset all cells to normal state
func reset_all_cells() -> void:
	for cell: GridCell in _cells:
		cell.reset_to_normal()
	queue_redraw()


## Highlight specific cells
func highlight_cells(positions: Array[Vector2i], state: GridCell.CellState) -> void:
	reset_all_cells()
	for pos: Vector2i in positions:
		set_cell_state(pos.x, pos.y, state)


## Handle mouse/touch input for cell detection
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		_handle_hover(event.position)
	elif event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			_handle_click(event.position)


## Handle hover event
func _handle_hover(screen_pos: Vector2) -> void:
	if grid_system == null:
		return

	# Convert screen position to local position
	var local_pos: Vector2 = to_local(screen_pos)
	var grid_pos: Vector2i = grid_system.screen_to_gridv(local_pos)

	if grid_pos != _hovered_cell:
		if grid_system.is_valid_cellv(grid_pos):
			_hovered_cell = grid_pos
			cell_hovered.emit(grid_pos)
		else:
			_hovered_cell = Vector2i(-1, -1)


## Handle click event
func _handle_click(screen_pos: Vector2) -> void:
	if grid_system == null:
		return

	# Convert screen position to local position
	var local_pos: Vector2 = to_local(screen_pos)
	var grid_pos: Vector2i = grid_system.screen_to_gridv(local_pos)

	if grid_system.is_valid_cellv(grid_pos):
		cell_clicked.emit(grid_pos)


## Get all cells
func get_all_cells() -> Array[GridCell]:
	return _cells.duplicate()


## Get cells by state
func get_cells_by_state(state: GridCell.CellState) -> Array[GridCell]:
	var result: Array[GridCell] = []
	for cell: GridCell in _cells:
		if cell.state == state:
			result.append(cell)
	return result
