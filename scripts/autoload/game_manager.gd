## GameManager.gd
## Global game state and coordination singleton.
## Manages game phase, player resources, and coordinates between autoloads.
extends Node

# Signals
signal resources_changed(currency_type: String, new_amount: int)
signal run_started()
signal run_ended(victory: bool)

# Constants
const CURRENCY_GOLD := "gold"
const CURRENCY_DIAMONDS := "diamonds"

# Enums
enum GamePhase { MENU, RUN, COMBAT }

# State
var current_phase: GamePhase = GamePhase.MENU
var _currencies: Dictionary = {
	CURRENCY_GOLD: 0,
	CURRENCY_DIAMONDS: 0
}


func _ready() -> void:
	# Load saved data on startup
	_load_player_data()


## Get current amount of a currency
func get_currency(type: String) -> int:
	return _currencies.get(type, 0)


## Spend currency if sufficient. Returns true if successful.
func spend_currency(type: String, amount: int) -> bool:
	if amount < 0:
		push_error("Cannot spend negative amount")
		return false

	var current := get_currency(type)
	if current < amount:
		return false

	_currencies[type] = current - amount
	resources_changed.emit(type, _currencies[type])
	return true


## Add currency to player's balance
func add_currency(type: String, amount: int) -> void:
	if amount < 0:
		push_error("Cannot add negative amount")
		return

	_currencies[type] = get_currency(type) + amount
	resources_changed.emit(type, _currencies[type])


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


func _load_player_data() -> void:
	if SaveManager:
		var data := SaveManager.load_player_data()
		if data and data.has("currencies"):
			_currencies = data.currencies


func _save_player_data() -> void:
	if SaveManager:
		var data := {
			"currencies": _currencies
		}
		SaveManager.save_player_data(data)
