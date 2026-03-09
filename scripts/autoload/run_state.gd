## RunState.gd
## Active run state management singleton.
## Tracks current run progress, manages run-specific unit levels, and generates maps.
extends Node

# Signals
signal node_entered(node_id: String)
signal node_completed(node_id: String)
signal run_ended(victory: bool)

# Constants
const MAX_RUN_LEVEL := 5
const MIN_RUN_LEVEL := 1

# Enums
enum RunStatus { INACTIVE, ACTIVE, COMPLETED, FAILED }

# State
var _status: RunStatus = RunStatus.INACTIVE
var _current_node_id: String = ""
var _map_seed: int = 0
var _nodes: Array = []
var _team: Array = []  # Array of RunUnit data
var _accumulated_rewards: Dictionary = {}
var _run_start_time: int = 0


## Start a new run with the given team preset
func start_run(team_preset_id: String) -> void:
	_status = RunStatus.ACTIVE
	_map_seed = randi()
	_run_start_time = Time.get_unix_time_from_system()

	# Initialize team from preset
	_initialize_team(team_preset_id)

	# Generate initial map
	_generate_map()

	# Save initial state for crash recovery
	_save_run_state()


## Get current run status
func get_status() -> RunStatus:
	return _status


## Check if a run is currently active
func is_run_active() -> bool:
	return _status == RunStatus.ACTIVE


## Get current node ID
func get_current_node() -> String:
	return _current_node_id


## Get all map nodes
func get_current_map() -> Array:
	return _nodes


## Advance to a specific node
func advance_to_node(node_id: String) -> void:
	if not is_run_active():
		push_error("Cannot advance node: no active run")
		return

	_current_node_id = node_id
	node_entered.emit(node_id)
	_save_run_state()


## Complete current node
func complete_current_node() -> void:
	node_completed.emit(_current_node_id)


## Get run units (team with current stats)
func get_run_units() -> Array:
	return _team


## Level up a specific unit during run
func level_up_unit(unit_index: int) -> bool:
	if unit_index < 0 or unit_index >= _team.size():
		return false

	var unit: Dictionary = _team[unit_index]
	var current_level: int = unit.get("level", 1)

	if current_level >= MAX_RUN_LEVEL:
		return false

	unit["level"] = current_level + 1
	_recalculate_unit_stats(unit_index)
	_save_run_state()
	return true


## Apply damage to a unit (returns true if unit died)
func damage_unit(unit_index: int, damage: int) -> bool:
	if unit_index < 0 or unit_index >= _team.size():
		return false

	var unit: Dictionary = _team[unit_index]
	var current_hp: int = unit.get("current_hp", 0)
	current_hp = max(0, current_hp - damage)
	unit["current_hp"] = current_hp

	if current_hp <= 0:
		unit["is_alive"] = false
		return true

	return false


## Heal a unit
func heal_unit(unit_index: int, amount: int) -> void:
	if unit_index < 0 or unit_index >= _team.size():
		return

	var unit: Dictionary = _team[unit_index]
	if not unit.get("is_alive", true):
		return

	var current_hp: int = unit.get("current_hp", 0)
	var max_hp: int = unit.get("max_hp", 100)
	unit["current_hp"] = min(max_hp, current_hp + amount)


## Revive a dead unit
func revive_unit(unit_index: int, hp_percent: float = 0.5) -> bool:
	if unit_index < 0 or unit_index >= _team.size():
		return false

	var unit: Dictionary = _team[unit_index]
	if unit.get("is_alive", true):
		return false

	unit["is_alive"] = true
	var max_hp: int = unit.get("max_hp", 100)
	unit["current_hp"] = int(max_hp * hp_percent)
	return true


## End the current run
func end_run(victory: bool) -> void:
	_status = RunStatus.COMPLETED if victory else RunStatus.FAILED
	run_ended.emit(victory)

	# Clear run save on completion
	if SaveManager:
		SaveManager.clear_run_state()


## Get accumulated rewards
func get_rewards() -> Dictionary:
	return _accumulated_rewards.duplicate()


## Add rewards from combat/node
func add_rewards(rewards: Dictionary) -> void:
	for key in rewards:
		var current: int = _accumulated_rewards.get(key, 0)
		_accumulated_rewards[key] = current + rewards[key]


func _initialize_team(team_preset_id: String) -> void:
	_team.clear()

	# TODO: Load actual preset from SaveManager
	# For now, create placeholder team
	for i in range(6):
		_team.append({
			"unit_id": "placeholder_unit_%d" % i,
			"level": MIN_RUN_LEVEL,
			"current_hp": 100,
			"max_hp": 100,
			"current_stats": {},
			"is_alive": true
		})


func _recalculate_unit_stats(unit_index: int) -> void:
	if unit_index < 0 or unit_index >= _team.size():
		return

	var unit: Dictionary = _team[unit_index]
	var level: int = unit.get("level", 1)

	# TODO: Get base stats from UnitDatabase and scale by level
	# Placeholder stat scaling
	unit["max_hp"] = 100 + (level - 1) * 20
	unit["current_hp"] = min(unit.get("current_hp", 100), unit["max_hp"])


func _generate_map() -> void:
	# TODO: Implement procedural map generation
	# For now, create placeholder nodes
	_nodes.clear()

	var node_types := ["combat", "combat", "healing", "combat", "boss"]
	for i in range(node_types.size()):
		_nodes.append({
			"id": "node_%d" % i,
			"type": node_types[i],
			"position": Vector2(i * 100, 0),
			"connections": ["node_%d" % (i + 1)] if i < node_types.size() - 1 else [],
			"completed": false
		})

	_current_node_id = _nodes[0]["id"]


func _save_run_state() -> void:
	if not SaveManager:
		return

	var run_data := {
		"status": _status,
		"current_node_id": _current_node_id,
		"map_seed": _map_seed,
		"nodes": _nodes,
		"team": _team,
		"accumulated_rewards": _accumulated_rewards,
		"run_start_time": _run_start_time
	}
	SaveManager.save_run_state(run_data)
