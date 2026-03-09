## TeamPreset.gd
## Represents a saved team configuration.
## Contains 6 unit slots for run deployment.
class_name TeamPreset
extends Resource

# Constants
const MAX_TEAM_SIZE := 6

# Exported properties
@export var id: String = ""
@export var name: String = "New Team"
@export var unit_ids: Array[String] = []  # 6 slots, empty string = empty slot
@export var created_timestamp: int = 0


func _init() -> void:
	# Initialize with empty slots
	unit_ids.resize(MAX_TEAM_SIZE)
	for i in range(MAX_TEAM_SIZE):
		unit_ids[i] = ""


## Add a unit to the first empty slot
func add_unit(unit_id: String) -> bool:
	if unit_id == "":
		return false

	for i in range(MAX_TEAM_SIZE):
		if unit_ids[i] == "":
			unit_ids[i] = unit_id
			return true
	return false


## Remove a unit from a specific slot
func remove_unit(slot_index: int) -> bool:
	if slot_index < 0 or slot_index >= MAX_TEAM_SIZE:
		return false

	unit_ids[slot_index] = ""
	return true


## Set a unit at a specific slot
func set_unit(slot_index: int, unit_id: String) -> bool:
	if slot_index < 0 or slot_index >= MAX_TEAM_SIZE:
		return false

	unit_ids[slot_index] = unit_id
	return true


## Get unit at a specific slot
func get_unit(slot_index: int) -> String:
	if slot_index < 0 or slot_index >= MAX_TEAM_SIZE:
		return ""
	return unit_ids[slot_index]


## Count filled slots
func get_unit_count() -> int:
	var count := 0
	for unit_id in unit_ids:
		if unit_id != "":
			count += 1
	return count


## Check if team is valid (at least 1 unit)
func is_valid() -> bool:
	return id != "" and get_unit_count() > 0


## Get all non-empty unit IDs
func get_filled_slots() -> Array[String]:
	var result: Array[String] = []
	for unit_id in unit_ids:
		if unit_id != "":
			result.append(unit_id)
	return result
