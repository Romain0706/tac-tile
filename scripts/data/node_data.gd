## NodeData.gd
## Represents a node on the run map.
## Contains type, position, connections, and encounter data.
class_name NodeData
extends Resource

# Enums
enum NodeType { COMBAT, HEALING, EVENT, BOSS }

# Exported properties
@export var id: String = ""
@export var type: NodeType = NodeType.COMBAT
@export var grid_position: Vector2i = Vector2i.ZERO  # Position in map grid
@export var connections: Array[String] = []  # IDs of connected nodes
@export var completed: bool = false
@export var encounter_id: String = ""  # Enemy group ID, event ID, etc.
@export var difficulty: int = 1  # 1-5 scale


## Check if this node can be entered from a given node
func can_enter_from(from_node_id: String) -> bool:
	return connections.has(from_node_id)


## Get node type as string
func get_type_name() -> String:
	match type:
		NodeType.COMBAT: return "Combat"
		NodeType.HEALING: return "Healing"
		NodeType.EVENT: return "Event"
		NodeType.BOSS: return "Boss"
		_: return "Unknown"


## Check if this node is a combat type
func is_combat() -> bool:
	return type == NodeType.COMBAT or type == NodeType.BOSS


## Serialize to dictionary
func to_dict() -> Dictionary:
	return {
		"id": id,
		"type": type,
		"grid_position": {"x": grid_position.x, "y": grid_position.y},
		"connections": connections,
		"completed": completed,
		"encounter_id": encounter_id,
		"difficulty": difficulty
	}


## Deserialize from dictionary
static func from_dict(data: Dictionary) -> NodeData:
	var node := NodeData.new()
	node.id = data.get("id", "")
	node.type = data.get("type", NodeType.COMBAT)
	var pos_data: Dictionary = data.get("grid_position", {"x": 0, "y": 0})
	node.grid_position = Vector2i(pos_data.get("x", 0), pos_data.get("y", 0))
	node.connections = data.get("connections", [])
	node.completed = data.get("completed", false)
	node.encounter_id = data.get("encounter_id", "")
	node.difficulty = data.get("difficulty", 1)
	return node
