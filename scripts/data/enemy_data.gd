## EnemyData.gd
## Static enemy definition resource.
## Contains stats, skills, AI behavior, and movement.
class_name EnemyData
extends Resource

# Enums
enum AiBehavior { AGGRESSIVE, DEFENSIVE, SUPPORT, RANDOM }

# Exported properties
@export var id: String = ""
@export var display_name: String = "Unknown Enemy"
@export var element: int = 0  # Use UnitData.Element values
@export var weapon_type: int = 0  # Use UnitData.WeaponType values
@export var hp: int = 50
@export var atk: int = 8
@export var def_stat: int = 5  # 'def' is reserved keyword
@export var matk: int = 5
@export var mdef: int = 5
@export var move_range: int = 2  # Movement range per turn
@export var skill_ids: Array[String] = []  # References to SkillData
@export var ai_behavior: AiBehavior = AiBehavior.AGGRESSIVE
@export var sprite_path: String = ""


## Get scaled stats for difficulty level
func get_scaled_stats(difficulty: int) -> Dictionary:
	var scale := 1.0 + (difficulty - 1) * 0.15  # 15% per difficulty level

	return {
		"hp": int(hp * scale),
		"atk": int(atk * scale),
		"def": int(def_stat * scale),
		"matk": int(matk * scale),
		"mdef": int(mdef * scale),
		"move_range": move_range
	}


## Check if this enemy is valid
func is_valid() -> bool:
	return id != "" and display_name != ""
