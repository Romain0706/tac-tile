## RunUnit.gd
## Represents a unit instance during a run.
## Tracks level, current HP, and modified stats.
class_name RunUnit
extends Resource

# Constants
const MAX_LEVEL := 5
const MIN_LEVEL := 1

# Exported properties
@export var unit_id: String = ""  # References UnitData.id
@export var level: int = 1
@export var current_hp: int = 100
@export var max_hp: int = 100
@export var atk: int = 10
@export var def_stat: int = 10  # 'def' is reserved keyword
@export var matk: int = 10
@export var mdef: int = 10
@export var is_alive: bool = true


## Create a run unit from base unit data at level 1
static func create_from_unit_data(unit_data: UnitData) -> RunUnit:
	var run_unit := RunUnit.new()
	run_unit.unit_id = unit_data.id
	run_unit.level = MIN_LEVEL
	run_unit._apply_base_stats(unit_data)
	return run_unit


## Level up this unit
func level_up() -> bool:
	if level >= MAX_LEVEL:
		return false

	level += 1
	return true


## Apply damage to this unit
func take_damage(amount: int) -> void:
	current_hp = max(0, current_hp - amount)
	if current_hp <= 0:
		is_alive = false


## Heal this unit
func heal(amount: int) -> void:
	if not is_alive:
		return
	current_hp = min(max_hp, current_hp + amount)


## Revive this unit with a percentage of max HP
func revive(hp_percent: float = 0.5) -> void:
	is_alive = true
	current_hp = int(max_hp * clampf(hp_percent, 0.0, 1.0))


## Apply base stats from UnitData
func _apply_base_stats(unit_data: UnitData) -> void:
	max_hp = unit_data.base_hp
	current_hp = max_hp
	atk = unit_data.base_atk
	def_stat = unit_data.base_def
	matk = unit_data.base_matk
	mdef = unit_data.base_mdef


## Scale stats based on current level
func scale_stats(base_stats: Dictionary) -> void:
	var scale := 1.0 + (level - 1) * 0.2
	max_hp = int(base_stats.get("hp", 100) * scale)
	atk = int(base_stats.get("atk", 10) * scale)
	def_stat = int(base_stats.get("def", 10) * scale)
	matk = int(base_stats.get("matk", 10) * scale)
	mdef = int(base_stats.get("mdef", 10) * scale)
	# Don't modify current_hp on stat scale (player must heal)


## Check if this run unit is valid
func is_valid() -> bool:
	return unit_id != ""


## Serialize to dictionary
func to_dict() -> Dictionary:
	return {
		"unit_id": unit_id,
		"level": level,
		"current_hp": current_hp,
		"max_hp": max_hp,
		"atk": atk,
		"def": def_stat,
		"matk": matk,
		"mdef": mdef,
		"is_alive": is_alive
	}


## Deserialize from dictionary
static func from_dict(data: Dictionary) -> RunUnit:
	var run_unit := RunUnit.new()
	run_unit.unit_id = data.get("unit_id", "")
	run_unit.level = data.get("level", 1)
	run_unit.current_hp = data.get("current_hp", 100)
	run_unit.max_hp = data.get("max_hp", 100)
	run_unit.atk = data.get("atk", 10)
	run_unit.def_stat = data.get("def", 10)
	run_unit.matk = data.get("matk", 10)
	run_unit.mdef = data.get("mdef", 10)
	run_unit.is_alive = data.get("is_alive", true)
	return run_unit
