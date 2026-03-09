## SaveManager.gd
## Persistent data storage and retrieval singleton.
## Handles saving/loading player data and run state for crash recovery.
## Uses Godot's ResourceSaver for native serialization.
extends Node

# Signals
signal save_completed()
signal load_completed()

# Constants
const PLAYER_DATA_PATH := "user://player_data.tres"
const RUN_SAVE_PATH := "user://run_save.tres"
const SAVE_VERSION := 1

# State
var _player_data: PlayerData = null


func _ready() -> void:
	_ensure_save_directory()


## Get the current player data (loads if not cached)
func get_player_data() -> PlayerData:
	if _player_data == null:
		_player_data = load_player_data()
	return _player_data


## Save player data to disk using ResourceSaver
func save_player_data(data: PlayerData = null) -> void:
	var to_save := data if data != null else _player_data
	if to_save == null:
		push_error("No player data to save")
		return

	# Update timestamp
	to_save.save_version = SAVE_VERSION

	var error := ResourceSaver.save(to_save, PLAYER_DATA_PATH)
	if error != OK:
		push_error("Failed to save player data: " + str(error))
		return

	_player_data = to_save
	save_completed.emit()


## Load player data from disk using ResourceLoader
func load_player_data() -> PlayerData:
	# Return cached data if available
	if _player_data != null:
		return _player_data

	# Check if save file exists
	if not ResourceLoader.exists(PLAYER_DATA_PATH):
		_player_data = _create_default_player_data()
		return _player_data

	# Load the resource
	var loaded := load(PLAYER_DATA_PATH)
	if loaded == null or not loaded is PlayerData:
		push_error("Failed to load player data or invalid type")
		_player_data = _create_default_player_data()
		return _player_data

	_player_data = loaded as PlayerData
	load_completed.emit()
	return _player_data


## Save run state for crash recovery
func save_run_state(data: RunSaveData) -> void:
	if data == null:
		push_error("No run data to save")
		return

	data.save_version = SAVE_VERSION
	data.save_timestamp = Time.get_unix_time_from_system()

	var error := ResourceSaver.save(data, RUN_SAVE_PATH)
	if error != OK:
		push_error("Failed to save run state: " + str(error))


## Load run state for crash recovery
func load_run_state() -> RunSaveData:
	if not ResourceLoader.exists(RUN_SAVE_PATH):
		return null

	var loaded := load(RUN_SAVE_PATH)
	if loaded == null or not loaded is RunSaveData:
		push_error("Failed to load run state or invalid type")
		return null

	return loaded as RunSaveData


## Check if there's a crash recovery available
func has_crash_recovery() -> bool:
	return ResourceLoader.exists(RUN_SAVE_PATH)


## Clear run save data (after run completion or player abandon)
func clear_run_state() -> void:
	if ResourceLoader.exists(RUN_SAVE_PATH):
		DirAccess.remove_absolute(RUN_SAVE_PATH)


## Create a new default player data
func _create_default_player_data() -> PlayerData:
	var data := PlayerData.new()
	data.save_version = SAVE_VERSION
	# PlayerData already has default starting diamonds (100)
	return data


func _ensure_save_directory() -> void:
	var dir := DirAccess.open("user://")
	if dir and not dir.dir_exists("saves"):
		dir.make_dir("saves")
