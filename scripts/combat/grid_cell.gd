## GridCell.gd
## Represents a single cell in the combat grid.
## Tracks position, occupancy, and visual state.
class_name GridCell
extends Resource

# Cell states for visual feedback
enum CellState {
	NORMAL,
	HIGHLIGHTED,
	SELECTED,
	MOVABLE,
	ATTACK_TARGET,
	PINCER_TARGET,
	CHAIN_TARGET
}

# Exported properties
@export var grid_position: Vector2i = Vector2i.ZERO
@export var state: CellState = CellState.NORMAL
@export var occupant_id: String = ""  # Unit ID if occupied, empty if free

# Colors for each state (can be customized)
var _state_colors: Dictionary = {
	CellState.NORMAL: Color.TRANSPARENT,
	CellState.HIGHLIGHTED: Color(0.3, 0.3, 0.8, 0.3),
	CellState.SELECTED: Color(0.2, 0.6, 0.2, 0.4),
	CellState.MOVABLE: Color(0.2, 0.8, 0.2, 0.3),
	CellState.ATTACK_TARGET: Color(0.8, 0.2, 0.2, 0.4),
	CellState.PINCER_TARGET: Color(0.8, 0.6, 0.0, 0.5),
	CellState.CHAIN_TARGET: Color(0.6, 0.4, 0.8, 0.4)
}


## Create a new GridCell at a specific position
static func create(col: int, row: int) -> GridCell:
	var cell := GridCell.new()
	cell.grid_position = Vector2i(col, row)
	return cell


## Check if this cell is occupied
func is_occupied() -> bool:
	return occupant_id != ""


## Check if this cell is empty
func is_empty() -> bool:
	return occupant_id == ""


## Get the column (x) position
func get_col() -> int:
	return grid_position.x


## Get the row (y) position
func get_row() -> int:
	return grid_position.y


## Get the color for the current state
func get_state_color() -> Color:
	return _state_colors.get(state, Color.TRANSPARENT)


## Set the cell state
func set_state(new_state: CellState) -> void:
	state = new_state


## Reset cell to normal state
func reset_state() -> void:
	state = CellState.NORMAL


## Set occupant
func set_occupant(unit_id: String) -> void:
	occupant_id = unit_id


## Clear occupant
func clear_occupant() -> void:
	occupant_id = ""


## Serialize to dictionary
func to_dict() -> Dictionary:
	return {
		"col": grid_position.x,
		"row": grid_position.y,
		"state": state,
		"occupant_id": occupant_id
	}


## Deserialize from dictionary
static func from_dict(data: Dictionary) -> GridCell:
	var cell := GridCell.new()
	cell.grid_position = Vector2i(data.get("col", 0), data.get("row", 0))
	cell.state = data.get("state", CellState.NORMAL) as CellState
	cell.occupant_id = data.get("occupant_id", "")
	return cell
