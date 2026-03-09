## OwnedUnit.gd
## Represents a unit owned by the player.
## Tracks rarity, charges, and acquisition date.
class_name OwnedUnit
extends Resource

# Exported properties
@export var unit_id: String = ""  # References UnitData.id
@export var rarity: int = 3  # 3, 4, or 5 stars
@export var charges: int = 0
@export var obtained_timestamp: int = 0  # Unix timestamp


## Create from a unit pull
static func create_from_pull(unit_id: String, rarity: int) -> OwnedUnit:
	var owned := OwnedUnit.new()
	owned.unit_id = unit_id
	owned.rarity = rarity
	owned.charges = rarity - 1  # First draw gives (rarity - 1) charges
	owned.obtained_timestamp = Time.get_unix_time_from_system()
	return owned


## Add charges from a duplicate pull
func add_duplicate_charges(pulled_rarity: int) -> void:
	charges += pulled_rarity


## Check if this owned unit is valid
func is_valid() -> bool:
	return unit_id != ""
