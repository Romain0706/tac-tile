## PlayerData.gd
## Main player save data resource.
## Contains currencies, owned units, team presets, and settings.
class_name PlayerData
extends Resource

# Exported properties
@export var save_version: int = 1
@export var gold: int = 0
@export var diamonds: int = 100  # Starting diamonds
@export var owned_units: Array[OwnedUnit] = []
@export var team_presets: Array[TeamPreset] = []
@export var tutorial_completed: bool = false
@export var settings: Dictionary = {}


## Add gold
func add_gold(amount: int) -> void:
	gold += amount


## Spend gold (returns false if insufficient)
func spend_gold(amount: int) -> bool:
	if gold < amount:
		return false
	gold -= amount
	return true


## Add diamonds
func add_diamonds(amount: int) -> void:
	diamonds += amount


## Spend diamonds (returns false if insufficient)
func spend_diamonds(amount: int) -> bool:
	if diamonds < amount:
		return false
	diamonds -= amount
	return true


## Add a new owned unit
func add_owned_unit(unit: OwnedUnit) -> void:
	owned_units.append(unit)


## Find owned unit by unit_id
func find_owned_unit(unit_id: String) -> OwnedUnit:
	for unit in owned_units:
		if unit.unit_id == unit_id:
			return unit
	return null


## Check if player owns a specific unit
func owns_unit(unit_id: String) -> bool:
	return find_owned_unit(unit_id) != null


## Add a team preset
func add_team_preset(preset: TeamPreset) -> void:
	team_presets.append(preset)


## Remove a team preset by ID
func remove_team_preset(preset_id: String) -> bool:
	for i in range(team_presets.size()):
		if team_presets[i].id == preset_id:
			team_presets.remove_at(i)
			return true
	return false


## Find team preset by ID
func find_team_preset(preset_id: String) -> TeamPreset:
	for preset in team_presets:
		if preset.id == preset_id:
			return preset
	return null


## Get default team preset (first valid one, or create new)
func get_default_preset() -> TeamPreset:
	for preset in team_presets:
		if preset.is_valid():
			return preset

	# Create a new default preset if none exists
	var default := TeamPreset.new()
	default.id = "default"
	default.name = "Team 1"
	default.created_timestamp = Time.get_unix_time_from_system()
	add_team_preset(default)
	return default


## Serialize to dictionary
func to_dict() -> Dictionary:
	var owned_units_data: Array = []
	for unit in owned_units:
		owned_units_data.append({
			"unit_id": unit.unit_id,
			"rarity": unit.rarity,
			"charges": unit.charges,
			"obtained_timestamp": unit.obtained_timestamp
		})

	var presets_data: Array = []
	for preset in team_presets:
		presets_data.append({
			"id": preset.id,
			"name": preset.name,
			"unit_ids": preset.unit_ids,
			"created_timestamp": preset.created_timestamp
		})

	return {
		"save_version": save_version,
		"gold": gold,
		"diamonds": diamonds,
		"owned_units": owned_units_data,
		"team_presets": presets_data,
		"tutorial_completed": tutorial_completed,
		"settings": settings
	}


## Deserialize from dictionary
static func from_dict(data: Dictionary) -> PlayerData:
	var player_data := PlayerData.new()
	player_data.save_version = data.get("save_version", 1)
	player_data.gold = data.get("gold", 0)
	player_data.diamonds = data.get("diamonds", 100)
	player_data.tutorial_completed = data.get("tutorial_completed", false)
	player_data.settings = data.get("settings", {})

	# Load owned units
	for unit_data in data.get("owned_units", []):
		var unit := OwnedUnit.new()
		unit.unit_id = unit_data.get("unit_id", "")
		unit.rarity = unit_data.get("rarity", 3)
		unit.charges = unit_data.get("charges", 0)
		unit.obtained_timestamp = unit_data.get("obtained_timestamp", 0)
		player_data.owned_units.append(unit)

	# Load team presets
	for preset_data in data.get("team_presets", []):
		var preset := TeamPreset.new()
		preset.id = preset_data.get("id", "")
		preset.name = preset_data.get("name", "Team")
		preset.unit_ids = preset_data.get("unit_ids", [])
		preset.created_timestamp = preset_data.get("created_timestamp", 0)
		player_data.team_presets.append(preset)

	return player_data
