## GameManager.gd
## Global game state and coordination singleton.
## Manages game phase, player resources, and coordinates between autoloads.
extends Node

# Signals
signal resources_changed(currency_type: String, new_amount: int)
signal run_started()
signal run_ended(victory: bool)

# Enums
enum GamePhase { MENU, RUN, COMBAT }

# State
var current_phase: GamePhase = GamePhase.MENU


func _ready() -> void:
	# Load saved data on startup
	SaveManager.get_player_data()


## Get the player data resource
func get_player_data() -> PlayerData:
	return SaveManager.get_player_data()


## Get current gold amount
func get_gold() -> int:
	return get_player_data().gold


## Get current diamonds amount
func get_diamonds() -> int:
	return get_player_data().diamonds


## Spend gold if sufficient. Returns true if successful.
func spend_gold(amount: int) -> bool:
	if amount < 0:
		push_error("Cannot spend negative amount")
		return false

	var success := get_player_data().spend_gold(amount)
	if success:
		resources_changed.emit("gold", get_player_data().gold)
		_save_player_data()
	return success


## Spend diamonds if sufficient. Returns true if successful.
func spend_diamonds(amount: int) -> bool:
	if amount < 0:
		push_error("Cannot spend negative amount")
		return false

	var success := get_player_data().spend_diamonds(amount)
	if success:
		resources_changed.emit("diamonds", get_player_data().diamonds)
		_save_player_data()
	return success


## Add gold to player's balance
func add_gold(amount: int) -> void:
	if amount < 0:
		push_error("Cannot add negative amount")
		return

	get_player_data().add_gold(amount)
	resources_changed.emit("gold", get_player_data().gold)
	_save_player_data()


## Add diamonds to player's balance
func add_diamonds(amount: int) -> void:
	if amount < 0:
		push_error("Cannot add negative amount")
		return

	get_player_data().add_diamonds(amount)
	resources_changed.emit("diamonds", get_player_data().diamonds)
	_save_player_data()


## Start a new run with the given team preset
func start_run(team_preset_id: String) -> void:
	current_phase = GamePhase.RUN
	run_started.emit()
	# RunState will handle the actual run initialization


## End the current run
func end_run(victory: bool) -> void:
	current_phase = GamePhase.MENU
	run_ended.emit(victory)


## Get current game phase
func get_phase() -> GamePhase:
	return current_phase


## Handle app lifecycle
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			_save_player_data()
		NOTIFICATION_APPLICATION_PAUSED:
			_save_player_data()


func _save_player_data() -> void:
	if SaveManager:
		SaveManager.save_player_data()
