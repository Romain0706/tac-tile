## UIManager.gd
## UI coordination and transitions singleton.
## Manages scene transitions, modal dialogs, and toast notifications.
extends Node

# Signals
signal scene_changed(scene_path: String)
signal modal_opened()
signal modal_closed()

# Constants
const TRANSITION_DURATION := 0.3

# Enums
enum TransitionType { NONE, FADE, SLIDE }

# State
var _current_scene_path: String = ""
var _is_transitioning: bool = false
var _modal_stack: Array = []


## Change to a new scene with optional transition
func change_scene(scene_path: String, _transition: TransitionType = TransitionType.FADE) -> void:
	if _is_transitioning:
		push_warning("Scene change already in progress")
		return

	_is_transitioning = true

	# TODO: Add transition animation
	# For now, just change directly
	var error := get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error("Failed to change scene to: " + scene_path)
		_is_transitioning = false
		return

	_current_scene_path = scene_path
	scene_changed.emit(scene_path)
	_is_transitioning = false


## Show a modal dialog
func show_modal(modal_scene: PackedScene) -> void:
	if modal_scene == null:
		push_error("Cannot show null modal")
		return

	var modal_instance := modal_scene.instantiate()
	get_tree().current_scene.add_child(modal_instance)
	_modal_stack.append(modal_instance)
	modal_opened.emit()


## Close the topmost modal
func close_modal() -> void:
	if _modal_stack.is_empty():
		return

	var modal: Node = _modal_stack.pop_back()
	if is_instance_valid(modal):
		modal.queue_free()

	modal_closed.emit()


## Close all modals
func close_all_modals() -> void:
	while not _modal_stack.is_empty():
		close_modal()


## Show a toast notification
func show_toast(message: String, duration: float = 2.0) -> void:
	# TODO: Implement toast notification system
	print("TOAST: ", message, " (duration: ", duration, "s)")


## Check if any modal is open
func is_modal_open() -> bool:
	return not _modal_stack.is_empty()


## Get current scene path
func get_current_scene() -> String:
	return _current_scene_path


## Reload current scene
func reload_current_scene() -> void:
	if _current_scene_path.is_empty():
		push_warning("No current scene to reload")
		return

	change_scene(_current_scene_path)
