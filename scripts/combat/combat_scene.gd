## CombatScene.gd
## Main combat scene that contains the grid, units, and manages combat flow.
## This is the entry point for tactical combat in tac'tile.
extends Control

# Signals
signal combat_started
signal combat_ended(victory: bool)
signal turn_completed

# Child references
@onready var _grid_renderer: Node2D = $GridRenderer
@onready var _back_button: Button = $UILayer/TopBar/BackButton

# State
var _is_combat_active: bool = false


func _ready() -> void:
	_connect_signals()
	_setup_test_highlights()


func _connect_signals() -> void:
	if _grid_renderer == null:
		push_warning("GridRenderer not found in CombatScene")
		return

	_grid_renderer.cell_clicked.connect(_on_cell_clicked)
	_grid_renderer.cell_hovered.connect(_on_cell_hovered)

	if _back_button:
		_back_button.pressed.connect(_on_back_pressed)


## Initialize combat with enemies (placeholder for future implementation)
func start_combat(enemy_data: Array = []) -> void:
	_is_combat_active = true
	combat_started.emit()
	print("Combat started!")


## End combat (placeholder for future implementation)
func end_combat(victory: bool) -> void:
	_is_combat_active = false
	combat_ended.emit(victory)
	print("Combat ended. Victory: ", victory)


## Handle cell click
func _on_cell_clicked(grid_position: Vector2i) -> void:
	print("Cell clicked: ", grid_position)

	# Toggle highlight for testing
	if _grid_renderer:
		var cell: GridCell = _grid_renderer.get_cellv(grid_position)
		if cell:
			if cell.state == GridCell.CellState.NORMAL:
				_grid_renderer.set_cell_state(grid_position.x, grid_position.y, GridCell.CellState.SELECTED)
			else:
				_grid_renderer.set_cell_state(grid_position.x, grid_position.y, GridCell.CellState.NORMAL)


## Handle cell hover
func _on_cell_hovered(grid_position: Vector2i) -> void:
	# Can be used for tooltips or previews
	pass


## Handle back button press
func _on_back_pressed() -> void:
	if UIManager:
		UIManager.change_scene("res://scenes/menu/main_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")


## Setup test highlights to verify grid rendering
func _setup_test_highlights() -> void:
	if _grid_renderer == null:
		return

	# Highlight a few cells for visual testing
	_grid_renderer.set_cell_state(0, 0, GridCell.CellState.PINCER_TARGET)
	_grid_renderer.set_cell_state(5, 7, GridCell.CellState.CHAIN_TARGET)
	_grid_renderer.set_cell_state(2, 3, GridCell.CellState.MOVABLE)
	_grid_renderer.set_cell_state(3, 4, GridCell.CellState.ATTACK_TARGET)
