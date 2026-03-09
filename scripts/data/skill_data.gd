## SkillData.gd
## Skill definition resource.
## Contains skill type, AOE pattern, effects, and scaling.
class_name SkillData
extends Resource

# Enums
enum SkillType { PINCER, CHAIN, PASSIVE }
enum AoePattern {
	NONE,  # Only affects pincered enemies
	ADJACENT,  # Units next to caster
	ALL,  # All units on field
	AREA_1,  # 1 space around caster
	AREA_2,  # 2 spaces around caster
	CROSS_1,  # 1 space in 4 directions
	CROSS_2,  # 2 spaces in 4 directions
	LATERAL_1,  # 1 space left/right
	LATERAL_2,  # 2 spaces left/right
	VERTICAL_1,  # 1 space up/down
	VERTICAL_2,  # 2 spaces up/down
	SELF,  # Only affects caster
	CHAIN,  # All units in chain
	PINCER_AREA,  # Area around pincered enemy
	PINCER_COLUMN,  # Column containing pincered
	PINCER_ROW,  # Row containing pincered
	ROW_ALL,  # Entire row
	COLUMN_ALL,  # Entire column
	DIAMOND_1,  # Diamond shape around caster
	RING_1  # Ring around caster
}
enum EffectType { DAMAGE, HEAL, BUFF, DEBUFF }

# Exported properties
@export var id: String = ""
@export var display_name: String = "Unknown Skill"
@export var description: String = ""
@export var skill_type: SkillType = SkillType.PINCER
@export var aoe_pattern: AoePattern = AoePattern.NONE
@export var effect_type: EffectType = EffectType.DAMAGE
@export var base_power: int = 1  # 1, 2, or 3 for basic/advanced/ultimate
@export var element: int = -1  # -1 for physical, else use UnitData.Element
@export var level_scaling: Array[float] = [1.0, 1.1, 1.2, 1.3, 1.5]  # Multiplier per level 1-5


## Get power multiplier for a given level
func get_power_multiplier(level: int) -> float:
	var index := clampi(level - 1, 0, level_scaling.size() - 1)
	return level_scaling[index]


## Check if this is a pincer skill
func is_pincer_skill() -> bool:
	return skill_type == SkillType.PINCER


## Check if this is a chain skill
func is_chain_skill() -> bool:
	return skill_type == SkillType.CHAIN


## Check if this is a passive skill
func is_passive_skill() -> bool:
	return skill_type == SkillType.PASSIVE


## Check if uses magic (element-based)
func is_magical() -> bool:
	return element >= 0


## Validate the skill data
func is_valid() -> bool:
	return id != "" and display_name != ""
