## main.gd
## Main entry point scene script.
## Handles initial game setup and navigation to the main menu.
extends Control

@onready var _loading_label: Label = $VBoxContainer/LoadingLabel
@onready var _version_label: Label = $VBoxContainer/VersionLabel


func _ready() -> void:
	_setup_ui()
	await _initialize_game()
	_goto_main_menu()


func _setup_ui() -> void:
	# Set up anchors for portrait layout
	anchor_right = 1.0
	anchor_bottom = 1.0

	if _loading_label:
		_loading_label.text = "Loading..."
		_loading_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	if _version_label:
		var config := ConfigFile.new()
		var version := "0.1.0"
		if config.load("res://project.godot") == OK:
			version = config.get_value("application", "config/version", version)
		_version_label.text = "v%s" % version
		_version_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER


func _initialize_game() -> void:
	# Wait for autoloads to initialize
	await get_tree().process_frame

	# Initialize save data
	if SaveManager:
		SaveManager.load_player_data()

	# Load unit database
	if UnitDatabase:
		UnitDatabase.load_units()

	# Small delay for visual feedback
	await get_tree().create_timer(0.5).timeout


func _goto_main_menu() -> void:
	if UIManager:
		UIManager.change_scene("res://scenes/menu/main_menu.tscn")
	else:
		# Fallback if UIManager not available
		get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
