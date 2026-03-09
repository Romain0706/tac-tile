## main_menu.gd
## Main menu scene script.
## Central hub for accessing all game features.
extends Control

# Button references
@onready var _run_button: Button = $VBoxContainer/ButtonContainer/RunButton
@onready var _team_button: Button = $VBoxContainer/ButtonContainer/TeamButton
@onready var _gacha_button: Button = $VBoxContainer/ButtonContainer/GachaButton
@onready var _collection_button: Button = $VBoxContainer/ButtonContainer/CollectionButton
@onready var _settings_button: Button = $VBoxContainer/ButtonContainer/SettingsButton

# Currency display
@onready var _gold_label: Label = $VBoxContainer/CurrencyContainer/HBoxContainer/GoldLabel
@onready var _diamonds_label: Label = $VBoxContainer/CurrencyContainer/HBoxContainer/DiamondsLabel


func _ready() -> void:
	_connect_signals()
	_update_currency_display()


func _connect_signals() -> void:
	if _run_button:
		_run_button.pressed.connect(_on_run_pressed)
	if _team_button:
		_team_button.pressed.connect(_on_team_pressed)
	if _gacha_button:
		_gacha_button.pressed.connect(_on_gacha_pressed)
	if _collection_button:
		_collection_button.pressed.connect(_on_collection_pressed)
	if _settings_button:
		_settings_button.pressed.connect(_on_settings_pressed)

	# Connect to currency changes
	if GameManager:
		GameManager.resources_changed.connect(_on_resources_changed)


func _update_currency_display() -> void:
	if not GameManager:
		return

	if _gold_label:
		_gold_label.text = str(GameManager.get_gold())
	if _diamonds_label:
		_diamonds_label.text = str(GameManager.get_diamonds())


func _on_resources_changed(_type: String, _amount: int) -> void:
	_update_currency_display()


func _on_run_pressed() -> void:
	print("Run button pressed - TODO: Navigate to run selection")


func _on_team_pressed() -> void:
	print("Team button pressed - TODO: Navigate to team builder")


func _on_gacha_pressed() -> void:
	print("Gacha button pressed - TODO: Navigate to gacha")


func _on_collection_pressed() -> void:
	print("Collection button pressed - TODO: Navigate to collection")


func _on_settings_pressed() -> void:
	print("Settings button pressed - TODO: Open settings modal")
