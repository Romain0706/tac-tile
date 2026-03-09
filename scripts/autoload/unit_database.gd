## UnitDatabase.gd
## Central repository of all unit definitions.
## Loads unit data from Resource files and provides lookup methods.
extends Node

# Constants
const UNITS_DIR := "res://data/units/"

# State
var _units: Dictionary = {}  # unit_id -> UnitData resource
var _loaded: bool = false


func _ready() -> void:
	load_units()


## Load all unit data from resource files
func load_units() -> void:
	_units.clear()

	var dir := DirAccess.open(UNITS_DIR)
	if dir == null:
		push_warning("Units directory not found: " + UNITS_DIR)
		_loaded = true
		return

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			var unit_path := UNITS_DIR + file_name
			var unit_resource := load(unit_path)
			if unit_resource and unit_resource is Resource:
				var unit_id := file_name.get_basename()
				_units[unit_id] = unit_resource
		file_name = dir.get_next()

	dir.list_dir_end()
	_loaded = true


## Get a unit by ID
func get_unit(unit_id: String) -> Resource:
	if not _loaded:
		load_units()
	return _units.get(unit_id)


## Get all units
func get_all_units() -> Array:
	if not _loaded:
		load_units()
	return _units.values()


## Get units filtered by rarity (3, 4, or 5 stars)
func get_units_by_rarity(rarity: int) -> Array:
	if not _loaded:
		load_units()

	var result := []
	for unit in _units.values():
		if unit.get("rarity") == rarity:
			result.append(unit)
	return result


## Get units filtered by element
func get_units_by_element(element: String) -> Array:
	if not _loaded:
		load_units()

	var result := []
	for unit in _units.values():
		if unit.get("element") == element:
			result.append(unit)
	return result


## Check if database has finished loading
func is_loaded() -> bool:
	return _loaded


## Get total number of units
func get_unit_count() -> int:
	return _units.size()
