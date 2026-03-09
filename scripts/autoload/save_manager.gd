## SaveManager.gd
## Persistent data storage and retrieval singleton.
## Handles saving/loading player data and run state for crash recovery.
extends Node

# Signals
signal save_completed()
signal load_completed()

# Constants
const PLAYER_DATA_PATH := "user://player_data.tres"
const RUN_SAVE_PATH := "user://run_save.tres"
const SAVE_VERSION := 1

# State
var _player_data_cache: Dictionary = {}


func _ready() -> void:
	_ensure_save_directory()


## Save player data to disk
func save_player_data(data: Dictionary) -> void:
	data["save_version"] = SAVE_VERSION
	data["save_timestamp"] = Time.get_unix_time_from_system()

	var file := FileAccess.open(PLAYER_DATA_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open player data file for writing: " + str(FileAccess.get_open_error()))
		return

	var json_string := JSON.stringify(data, "  ")
	file.store_string(json_string)
	file.close()

	_player_data_cache = data
	save_completed.emit()


## Load player data from disk
func load_player_data() -> Dictionary:
	if not _player_data_cache.is_empty():
		return _player_data_cache

	if not FileAccess.file_exists(PLAYER_DATA_PATH):
		_player_data_cache = _create_default_player_data()
		return _player_data_cache

	var file := FileAccess.open(PLAYER_DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("Failed to open player data file for reading")
		_player_data_cache = _create_default_player_data()
		return _player_data_cache

	var json_string := file.get_as_text()
	file.close()

	var json := JSON.new()
	var parse_result := json.parse(json_string)
	if parse_result != OK:
		push_error("Failed to parse player data JSON")
		_player_data_cache = _create_default_player_data()
		return _player_data_cache

	_player_data_cache = json.data
	load_completed.emit()
	return _player_data_cache


## Save run state for crash recovery
func save_run_state(run_data: Dictionary) -> void:
	run_data["save_version"] = SAVE_VERSION
	run_data["save_timestamp"] = Time.get_unix_time_from_system()

	var file := FileAccess.open(RUN_SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open run save file for writing")
		return

	var json_string := JSON.stringify(run_data, "  ")
	file.store_string(json_string)
	file.close()


## Load run state for crash recovery
func load_run_state() -> Dictionary:
	if not FileAccess.file_exists(RUN_SAVE_PATH):
		return {}

	var file := FileAccess.open(RUN_SAVE_PATH, FileAccess.READ)
	if file == null:
		return {}

	var json_string := file.get_as_text()
	file.close()

	var json := JSON.new()
	if json.parse(json_string) != OK:
		return {}

	return json.data


## Check if there's a crash recovery available
func has_crash_recovery() -> bool:
	return FileAccess.file_exists(RUN_SAVE_PATH)


## Clear run save data (after run completion or player abandon)
func clear_run_state() -> void:
	if FileAccess.file_exists(RUN_SAVE_PATH):
		DirAccess.remove_absolute(RUN_SAVE_PATH)


func _ensure_save_directory() -> void:
	var dir := DirAccess.open("user://")
	if dir and not dir.dir_exists("saves"):
		dir.make_dir("saves")


func _create_default_player_data() -> Dictionary:
	return {
		"save_version": SAVE_VERSION,
		"currencies": {
			"gold": 0,
			"diamonds": 100  # Starting diamonds for new players
		},
		"owned_units": [],
		"team_presets": [],
		"settings": {},
		"tutorial_completed": false
	}
