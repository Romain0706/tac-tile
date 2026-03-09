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
var _team: Array[RunUnit] = []
var _accumulated_rewards: Dictionary = {}
var _run_start_time: int = 0


## Start a new run with the given team preset
func start_run(team_preset_id: String) -> void:
	_status = RunStatus.ACTIVE
	_map_seed = randi()
	_run_start_time = int(Time.get_unix_time_from_system())

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
func get_run_units() -> Array[RunUnit]:
	return _team


## Level up a specific unit during run
func level_up_unit(unit_index: int) -> bool:
	if unit_index < 0 or unit_index >= _team.size():
		return false

	var unit := _team[unit_index]
	if unit.level >= MAX_RUN_LEVEL:
		return false

	unit.level_up()
	_recalculate_unit_stats(unit_index)
	_save_run_state()
	return true


## Apply damage to a unit (returns true if unit died)
func damage_unit(unit_index: int, damage: int) -> bool:
	if unit_index < 0 or unit_index >= _team.size():
		return false

	var unit := _team[unit_index]
	unit.take_damage(damage)

	if unit.current_hp <= 0:
		return true
	return false


## Heal a unit
func heal_unit(unit_index: int, amount: int) -> void:
	if unit_index < 0 or unit_index >= _team.size():
		return

	var unit := _team[unit_index]
	unit.heal(amount)


## Revive a dead unit
func revive_unit(unit_index: int, hp_percent: float = 0.5) -> bool:
	if unit_index < 0 or unit_index >= _team.size():
		return false

	var unit := _team[unit_index]
	if unit.is_alive:
		return false

	unit.revive(hp_percent)
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


## Restore run state from a RunSaveData resource
func restore_from_save(save_data: RunSaveData) -> void:
	if save_data == null:
		return

	_status = save_data.status as RunStatus
	_current_node_id = save_data.current_node_id
	_map_seed = save_data.map_seed
	_nodes = save_data.nodes.duplicate(true)
	_team = save_data.team.duplicate()
	_accumulated_rewards = save_data.accumulated_rewards.duplicate(true)
	_run_start_time = save_data.run_start_time


## Create a RunSaveData from current state
func create_save_data() -> RunSaveData:
	var save_data := RunSaveData.new()
	save_data.status = _status
	save_data.current_node_id = _current_node_id
	save_data.map_seed = _map_seed
	save_data.nodes = _nodes.duplicate(true)
	save_data.team = _team.duplicate()
	save_data.accumulated_rewards = _accumulated_rewards.duplicate(true)
	save_data.run_start_time = _run_start_time
	return save_data


func _initialize_team(_team_preset_id: String) -> void:
	_team.clear()

	# TODO: Load actual preset from SaveManager
	# For now, create placeholder team using RunUnit resources
	for i in range(6):
		var run_unit := RunUnit.new()
		run_unit.unit_id = "placeholder_unit_%d" % i
		run_unit.level = MIN_RUN_LEVEL
		run_unit.max_hp = 100
		run_unit.current_hp = 100
		run_unit.is_alive = true
		_team.append(run_unit)


func _recalculate_unit_stats(unit_index: int) -> void:
	if unit_index < 0 or unit_index >= _team.size():
		return

	var unit := _team[unit_index]

	# TODO: Get base stats from UnitDatabase and scale by level
	# Placeholder stat scaling
	var new_max_hp := 100 + (unit.level - 1) * 20
	unit.max_hp = new_max_hp
	unit.current_hp = min(unit.current_hp, new_max_hp)


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

	var save_data := create_save_data()
	SaveManager.save_run_state(save_data)
