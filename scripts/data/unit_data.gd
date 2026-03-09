## UnitData.gd
## Static unit definition resource.
## Contains base stats, skills, element, and rarity for a unit.
class_name UnitData
extends Resource

# Enums
enum Element { FIRE, ICE, LIGHTNING, LIGHT, DARK }
enum WeaponType { MELEE, DISTANCE, REACH, MAGIC }

# Exported properties
@export var id: String = ""
@export var display_name: String = "Unknown"
@export var description: String = ""
@export var element: Element = Element.FIRE
@export var weapon_type: WeaponType = WeaponType.MELEE
@export var rarity: int = 3  # 3, 4, or 5 stars
@export var base_hp: int = 100
@export var base_atk: int = 10
@export var base_def: int = 10
@export var base_matk: int = 10
@export var base_mdef: int = 10
@export var pincer_skill_id: String = ""  # Reference to SkillData
@export var chain_skill_id: String = ""  # Reference to SkillData
@export var passive_skill_id: String = ""  # Reference to SkillData
@export var sprite_path: String = ""


## Get scaled stats for a given level (1-5)
func get_scaled_stats(level: int) -> Dictionary:
	var clamped_level := clampi(level, 1, 5)
	var scale: float = 1.0 + (clamped_level - 1) * 0.2  # 20% per level

	return {
		"hp": int(float(base_hp) * scale),
		"atk": int(float(base_atk) * scale),
		"def": int(float(base_def) * scale),
		"matk": int(float(base_matk) * scale),
		"mdef": int(float(base_mdef) * scale)
	}


## Validate the unit data
func is_valid() -> bool:
	return id != "" and display_name != ""
