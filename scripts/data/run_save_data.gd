## RunSaveData.gd
## Container for run state persistence.
## Used by SaveManager for crash recovery.
class_name RunSaveData
extends Resource

# Exported properties
@export var status: int = 0  # RunState.RunStatus enum value
@export var current_node_id: String = ""
@export var map_seed: int = 0
@export var nodes: Array = []  # Array of dictionaries
@export var team: Array[RunUnit] = []  # RunUnit resources
@export var accumulated_rewards: Dictionary = {}
@export var run_start_time: int = 0
@export var save_version: int = 1
@export var save_timestamp: int = 0


## Mark this resource for saving (needed for sub-resources)
func _init() -> void:
	# Ensure sub-resources are saved inline
	resource_local_to_scene = true
