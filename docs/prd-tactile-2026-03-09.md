# Product Requirements Document: tac'tile

**Date:** 2026-03-09
**Author:** rboniface
**Version:** 1.0
**Project Type:** Game
**Project Level:** 3 (Complex)
**Status:** Draft

---

## Document Overview

This Product Requirements Document (PRD) defines the functional and non-functional requirements for tac'tile. It serves as the source of truth for what will be built and provides traceability from requirements through implementation.

**Related Documents:**
- Product Brief: docs/product-brief-tactile-2026-03-08.md

---

## Executive Summary

tac'tile is a roguelite tactical RPG that combines Terra Battle's signature combat system with run-based roguelite progression and gacha-style character collection. Players send their units on runs to gather loot and currencies, then invest those resources to permanently improve their roster through gacha summons. The game targets gacha enthusiasts, tactical strategy fans, and theory crafters.

---

## Product Goals

### Business Objectives

- Launch a commercial mobile game as free-to-play with gacha monetization
- Achieve sustainable indie income (not aiming for hit scale, but long-term viability)
- Fill an underserved niche in the mobile tactical RPG market

### Success Metrics

- Retention rates (Day 1, 7, 30) - specific targets TBD
- Revenue targets - specific numbers TBD
- Daily/Monthly active users

---

## Functional Requirements

Functional Requirements (FRs) define **what** the system does - specific features and behaviors.

Each requirement includes:
- **ID**: Unique identifier (FR-001, FR-002, etc.)
- **Priority**: Must Have / Should Have / Could Have / Won't Have (MoSCoW)
- **Description**: What the system should do
- **Acceptance Criteria**: How to verify it's complete

---

### Combat System

#### FR-001: Grid-Based Movement

**Priority:** Must Have

**Description:**
Player drags ONE unit per turn across a 6x8 grid (6 columns, 8 rows). Moving over a friendly unit swaps their positions. Player has 4 seconds to complete movement (timer starts when unit leaves current square). Turn ends when unit is released OR timer runs out. Diagonal movement is allowed. Cannot move through enemies.

**Acceptance Criteria:**
- [ ] One unit can be dragged per turn
- [ ] Moving through ally swaps positions
- [ ] 4-second timer visible during movement
- [ ] Turn ends on release or timer expiration
- [ ] Diagonal movement works
- [ ] Cannot pass through enemies

---

#### FR-002: Pincer Attack System

**Priority:** Must Have

**Description:**
Pincering is the PRIMARY method of attack (no attacks without pincer). Sandwich an enemy between two allied units (horizontal, vertical, or corner positions). Damage calculated using ATK vs DEF. Affected by Circle of Carnage (weapon triangle: melee > distance > reach > melee). "Pincer skills" activate during pincer attacks.

**Acceptance Criteria:**
- [ ] Pincer triggers when enemy is between two allies
- [ ] No damage occurs without pincer
- [ ] Horizontal, vertical, and corner pincers all work
- [ ] Circle of Carnage bonus/penalty applied for melee/distance/reach
- [ ] Magic attacks are NOT affected by Circle of Carnage
- [ ] Pincer skills activate automatically
- [ ] Visual feedback shows pincer activation

---

#### FR-003: Damage Calculation

**Priority:** Must Have

**Description:**
Damage is calculated using the following formulas:

**Physical Damage:**
- Base = 1.395 × [skill power] × (ATK^1.7) / (DEF^0.7)
- Actual = Base × RANDOM(0.9, 1.1)

**Magical Damage:**
- Base = 1.5 × [skill power] × (MATK^1.7) / (MDEF^0.7)
- Actual = Base × RANDOM(0.9, 1.1)

**Skill Power:** Determined by the skill (e.g., power 1, 2, 3 for basic/advanced/ultimate skills)

**Attack Types:**
- **Melee:** Affected by Circle of Carnage (melee > distance > reach > melee)
- **Distance:** Affected by Circle of Carnage
- **Reach:** Affected by Circle of Carnage
- **Magic:** NOT affected by Circle of Carnage; uses MATK vs MDEF

**Acceptance Criteria:**
- [ ] Physical damage uses ATK vs DEF formula
- [ ] Magical damage uses MATK vs MDEF formula
- [ ] Skill power multiplier applied correctly
- [ ] Random variance (0.9 to 1.1) applied
- [ ] Circle of Carnage applies only to melee/distance/reach
- [ ] Magic attacks bypass Circle of Carnage

---

#### FR-004: Chain Attack System

**Priority:** Must Have

**Description:**
Allies in the same row or column as a pincering unit (with no enemies/obstacles between) join the attack chain. Each chained unit grants an extra attack. Each unit can only chain to ONE pincering unit per turn. Only "Chain skills" activate from chains (not Pincer skills).

**Chain Resolution Order:**

In a single pincer, attacks resolve in this order:

1. **First pincering character:**
   - Left unit for horizontal pincers
   - Bottom unit for vertical pincers
   - Left/right for corner pincers

2. **Second pincering character:**
   - Right unit for horizontal pincers
   - Top unit for vertical pincers
   - Bottom/top for corner pincers

3. **Chained characters (in order):**
   - First character right of the first pincering character
   - First character left of the first pincering character
   - First character above the first pincering character
   - First character below the first pincering character
   - First character right of the second pincering character
   - First character left of the second pincering character
   - First character above the second pincering character
   - First character below the second pincering character
   - Continue with next characters in each chain direction until all resolved

**Acceptance Criteria:**
- [ ] Allies in same row/column as pincering unit join chain
- [ ] No enemies/obstacles between chained unit and pincering unit
- [ ] Each chained unit adds an extra attack
- [ ] Each unit chains to only one pincering unit
- [ ] Only Chain skills activate (not Pincer skills)
- [ ] Chain count displayed during combat
- [ ] Visual feedback shows chain connections
- [ ] Chain resolution follows defined order

---

#### FR-005: Elemental System

**Priority:** Must Have

**Description:**
Five elements with the following relationships:
- **Triangle:** Fire > Ice > Lightning > Fire
- **Pair:** Light <--> Dark (mutual weakness, each strong against the other)
Units have one elemental type. Elemental advantage applies bonus damage; disadvantage applies penalty.

**Acceptance Criteria:**
- [ ] Five elements: Fire, Ice, Lightning, Light, Dark
- [ ] Triangle relationship: Fire > Ice > Lightning > Fire
- [ ] Light and Dark are mutually weak/strong against each other
- [ ] Elements visible on units
- [ ] Bonus damage for advantageous matchups
- [ ] Penalty damage for disadvantageous matchups

---

#### FR-006: Character Skills

**Priority:** Must Have

**Description:**
Each character has:
- **Attack Skill:** Either a Pincer skill OR a Chain skill (not both)
  - **Pincer Skill:** Activates when unit is one of the two units forming the pincer
  - **Chain Skill:** Activates when unit is part of a chain (including the pincering units, as they are the chain origin)
- **Passive Skill:** Always-on effect (applies continuously)

No cooldowns or resource costs. Skills are unique per character.

**Area of Effect Patterns:**
Skills can have various area-of-effect patterns:
- **None:** Only affects pincered enemies (default for weapon skills)
- **Equip:** Passive; always active during battle
- **Adjacent:** Affects units next to the caster (not caster itself)
- **All:** Affects all units on the field
- **Area (X):** Square within X spaces from caster
- **Cross (X):** Line X spaces in all 4 directions from caster
- **Lateral (X):** X spaces left and right of caster
- **Vertical (X):** X spaces above and below caster
- **Self:** Only affects the caster
- **Chain:** Affects all units in the chain
- **Pincer variants:** Pincer Area, Pincer Column, Pincer Row, Pincer Ring
- **Row/Column patterns:** X Column(s), X Row(s) centered at caster
- **Special:** Border, Corners, Diamond, Ring, 4x6 Grid, 2 Outer Rows/Columns

**Acceptance Criteria:**
- [ ] Each character has ONE attack skill (pincer OR chain, not both)
- [ ] Pincer skills activate when unit forms the pincer
- [ ] Chain skills activate when unit is in chain OR pincering (chain origin)
- [ ] Passive skills apply continuously
- [ ] Skills are unique per character
- [ ] Visual feedback for all skill types
- [ ] No cooldown or resource management
- [ ] AOE patterns apply correctly per skill definition

---

#### FR-007: Turn System

**Priority:** Must Have

**Description:**
Combat follows Terra Battle-style turn resolution:

**Player Turn:**
1. Movement phase (drag unit, 4-second timer)
2. Pincer attacks resolve
3. Buff skills apply
4. Attacks execute
5. Attack/debuff skills apply
6. Healing resolves
7. Enemy counters (if applicable)
8. Repeat until all pincers resolved

**Enemy Turn:**
1. Enemy movement
2. Enemy pincers (if positioned to pincer player units) OR enemy skills (if cannot pincer)
3. Player counters (if applicable)
4. Enemy skills resolve
5. Repeat until all enemies acted

**After Enemy Turn:**
1. Status effect damage
2. Regen healing
3. Buff/debuff counters reduced by 1

**Win/Lose Conditions:**
- Win: All enemies defeated
- Lose: 0 or 1 allies remaining

**Acceptance Criteria:**
- [ ] Player turn follows resolution order
- [ ] Enemy turn follows resolution order
- [ ] Status effects apply after enemy turn
- [ ] Win condition: all enemies defeated
- [ ] Lose condition: 0 or 1 allies remain
- [ ] Clear visual feedback for each phase

---

### Run Structure

#### FR-008: Node-Based Map

**Priority:** Must Have

**Description:**
Runs are presented as a node-based map with four node types: Combat, Healing, Events, Boss. Player selects next node to progress.

**Acceptance Criteria:**
- [ ] Map displays connected nodes
- [ ] Each node type is visually distinct
- [ ] Player selects next node to proceed

---

#### FR-009: Procedural Map Generation

**Priority:** Must Have

**Description:**
Run maps are procedurally generated with randomized encounters and layouts.

**Acceptance Criteria:**
- [ ] Each run has a different map
- [ ] Node distribution varies between runs
- [ ] Layout is non-deterministic

---

#### FR-010: Combat Nodes

**Priority:** Must Have

**Description:**
Standard combat encounters that spawn enemy fights.

**Acceptance Criteria:**
- [ ] Combat nodes are identifiable on map
- [ ] Spawns enemy encounters on entry
- [ ] Node completes on combat victory

---

#### FR-011: Healing Nodes

**Priority:** Must Have

**Description:**
Healing nodes offer a choice: heal 30% HP to all alive units OR revive one random dead unit.

**Acceptance Criteria:**
- [ ] Player chooses between heal/revive
- [ ] Effect applied immediately on selection
- [ ] Visual feedback shows healing effect

---

#### FR-012: Event Nodes

**Priority:** Must Have

**Description:**
Random events that present choices or outcomes to the player. Specific event types TBD.

**Acceptance Criteria:**
- [ ] Event triggers on node entry
- [ ] Player makes choice or receives outcome
- [ ] Result applied to run state

---

#### FR-013: Boss Encounters

**Priority:** Must Have

**Description:**
Special boss fights at key points (mid-run and/or final). Bosses are stronger than regular enemies with unique mechanics.

**Acceptance Criteria:**
- [ ] Bosses are stronger than regular enemies
- [ ] Bosses have unique mechanics/behaviors
- [ ] Significant challenge presented

---

#### FR-014: Run Completion Rewards

**Priority:** Must Have

**Description:**
Upon completing a run (winning final boss), players receive all accumulated loot and currencies.

**Acceptance Criteria:**
- [ ] Rewards displayed on victory screen
- [ ] Gold and any other currencies added to player account
- [ ] Clear breakdown of rewards earned

---

#### FR-015: Run Failure Handling

**Priority:** Must Have

**Description:**
When player loses (0 or 1 allies remaining), run ends with reduced or no rewards.

**Acceptance Criteria:**
- [ ] Defeat screen shown
- [ ] Reduced/no rewards granted
- [ ] Player returns to main menu

---

### Progression System

#### FR-016: Character Stats

**Priority:** Must Have

**Description:**
- **Allies have:** HP, ATK, DEF, MATK, MDEF
- **Enemies have:** HP, ATK, DEF, MATK, MDEF, MOVE (movement range)

**Acceptance Criteria:**
- [ ] Stats visible on character screens
- [ ] Stats used in combat damage/defense calculations
- [ ] Enemy MOVE affects their behavior

---

#### FR-017: Run-Based Leveling

**Priority:** Must Have

**Description:**
Each unit starts a run at Level 1 and can level up to Level 5 during that run. Levels reset between runs (no permanent unit levels).

**Acceptance Criteria:**
- [ ] All units start at Lvl 1 at run start
- [ ] Maximum Lvl 5 achievable
- [ ] Level displays on unit during run
- [ ] Levels reset on new run

---

#### FR-018: Post-Combat Draft System

**Priority:** Must Have

**Description:**
After winning combat, the system randomly selects 3 units from the player's team. Player chooses ONE unit to upgrade. Upgrading increases the unit's level (+1 to stats) AND improves both active and passive skills.

**Acceptance Criteria:**
- [ ] Draft screen shows 3 random units after combat
- [ ] Player picks one unit to upgrade
- [ ] Unit gains +1 level and stat increase
- [ ] Both active and passive skills improve
- [ ] Cannot exceed Lvl 5

---

### Gacha & Collection

#### FR-019: Gacha Banners

**Priority:** Must Have

**Description:**
Players can spend Diamonds (premium currency) to pull from gacha banners for new characters.

**Acceptance Criteria:**
- [ ] Banner screen displays available banners
- [ ] Pull cost shown in Diamonds
- [ ] Pull animation plays on purchase

---

#### FR-020: Pull Rates & Rarity

**Priority:** Must Have

**Description:**
Characters have 3-star, 4-star, and 5-star rarity tiers with defined pull rates.

**Acceptance Criteria:**
- [ ] Pull rates displayed to player
- [ ] Rarity affects base stats
- [ ] Visual distinction by star rating

---

#### FR-021: Character Collection & Duplicates

**Priority:** Must Have

**Description:**
- **First draw of a unit:** Obtain at full rarity + (rarity - 1) charges (e.g., 5-star -> 5-star unit + 4 charges)
- **Subsequent draws:** Adds charges equal to full star rating (e.g., 5-star duplicate -> +5 charges)
- Charges are a resource for future features (TBD)

**Acceptance Criteria:**
- [ ] Units obtained at correct rarity
- [ ] First draw awards (rarity - 1) charges
- [ ] Duplicates award full rarity in charges
- [ ] Charge count visible on unit details

---

#### FR-022: Team Building

**Priority:** Must Have

**Description:**
Players build teams of 6 units from their collection. Multiple team presets can be saved. One preset is selected for runs.

**Acceptance Criteria:**
- [ ] Team editor enforces 6-unit limit
- [ ] Only owned units are selectable
- [ ] Multiple presets can be saved/loaded/renamed
- [ ] One preset selected for run

---

### Core UI

#### FR-023: Main Menu

**Priority:** Must Have

**Description:**
Central hub for accessing all game features: Run, Team, Gacha, Collection, Settings.

**Acceptance Criteria:**
- [ ] All features accessible from menu
- [ ] Navigation is clear and intuitive
- [ ] Player resources (Diamonds, Gold) displayed

---

#### FR-024: Unit Collection Screen

**Priority:** Must Have

**Description:**
View all owned units with stats, skills, element, rarity, and charges.

**Acceptance Criteria:**
- [ ] All owned units browsable
- [ ] Unit details viewable (stats, skills, etc.)
- [ ] Sort/filter options available

---

#### FR-025: Run Selection Screen

**Priority:** Must Have

**Description:**
Select a team preset and start a new run.

**Acceptance Criteria:**
- [ ] Team presets selectable
- [ ] Run initiates on confirmation
- [ ] Selected team displayed

---

#### FR-026: Combat UI

**Priority:** Must Have

**Description:**
Displays grid, units, HP bars, turn timer, element icons, and skill indicators.

**Acceptance Criteria:**
- [ ] All combat information visible
- [ ] Drag controls responsive
- [ ] Win/lose states clearly displayed
- [ ] HP bars and element icons readable

---

#### FR-027: Gacha Interface

**Priority:** Must Have

**Description:**
Banner selection, pull animation, and results display.

**Acceptance Criteria:**
- [ ] Banners browsable
- [ ] Pull cost shown
- [ ] Results clearly displayed after pull

---

#### FR-028: Currency Display

**Priority:** Must Have

**Description:**
Two currencies: Diamonds (premium, for gacha) and Gold (free, earned from runs).

**Acceptance Criteria:**
- [ ] Both currencies visible on relevant screens
- [ ] Currency amounts update in real-time
- [ ] Clear visual distinction between currencies

---

## Non-Functional Requirements

Non-Functional Requirements (NFRs) define **how** the system performs - quality attributes and constraints.

---

### Performance

#### NFR-001: Frame Rate

**Priority:** Must Have

**Description:**
Game maintains 60 FPS during combat and UI navigation.

**Acceptance Criteria:**
- [ ] FPS counter shows 60 FPS on target devices
- [ ] No frame drops during combat animations
- [ ] Smooth UI transitions

**Rationale:**
Tactical combat requires visual clarity; low FPS impacts gameplay experience.

---

#### NFR-002: Load Times

**Priority:** Must Have

**Description:**
Initial game load < 5 seconds, scene transitions < 3 seconds.

**Acceptance Criteria:**
- [ ] Measured on mid-range devices
- [ ] Progress indicators shown during loading
- [ ] Initial load completes within 5 seconds

**Rationale:**
Long load times cause player frustration and abandonment.

---

#### NFR-003: Touch Responsiveness

**Priority:** Must Have

**Description:**
Touch input response < 100ms for all interactions.

**Acceptance Criteria:**
- [ ] Drag controls feel responsive
- [ ] No perceptible input lag
- [ ] All buttons respond immediately

**Rationale:**
Combat relies on drag controls; lag feels broken.

---

### Compatibility

#### NFR-004: OS Support

**Priority:** Must Have

**Description:**
iOS 13+ and Android 8.0+ (64-bit only).

**Acceptance Criteria:**
- [ ] Game launches and runs on minimum OS versions
- [ ] Crashes gracefully on unsupported devices
- [ ] Store listing reflects requirements

**Rationale:**
Cover majority of mobile market while avoiding legacy device issues.

---

#### NFR-005: Hardware

**Priority:** Must Have

**Description:**
Minimum 2GB RAM, supports both phones and tablets. Portrait orientation only.

**Acceptance Criteria:**
- [ ] Game runs on low-end devices meeting specs
- [ ] UI scales for different screen sizes
- [ ] Portrait orientation enforced

**Rationale:**
Tactical grid works well in portrait; broad device support increases addressable market.

---

### Usability

#### NFR-006: Touch Interface

**Priority:** Must Have

**Description:**
All interactive elements have minimum 44px touch targets with clear visual feedback on tap/drag.

**Acceptance Criteria:**
- [ ] No misclicks during usability testing
- [ ] Visual feedback on all interactions
- [ ] Touch targets meet minimum size

**Rationale:**
Mobile-first game requires mobile-friendly controls.

---

#### NFR-007: Readability

**Priority:** Must Have

**Description:**
Text is readable on mobile screens (minimum 14pt), high contrast for combat info.

**Acceptance Criteria:**
- [ ] Text legible on small screens
- [ ] HP/stats readable during combat
- [ ] High contrast for critical information

**Rationale:**
Players need to read stats quickly during combat.

---

### Reliability

#### NFR-008: Local Save

**Priority:** Must Have

**Description:**
Player data (collection, currencies, settings) saved locally on device.

**Acceptance Criteria:**
- [ ] Data persists between sessions
- [ ] Data survives app close
- [ ] Save occurs at appropriate checkpoints

**Rationale:**
Progress loss causes player frustration and churn.

---

#### NFR-009: Crash Recovery

**Priority:** Must Have

**Description:**
If game crashes during a run, player can resume from the start of current combat/node.

**Acceptance Criteria:**
- [ ] Run state saved at each node entry
- [ ] Resume option appears on relaunch after crash
- [ ] No progress lost beyond current node

**Rationale:**
Mobile games crash; players shouldn't lose entire runs.

---

#### NFR-010: Offline Play

**Priority:** Must Have

**Description:**
Entire game playable without internet connection (MVP).

**Acceptance Criteria:**
- [ ] No network calls required
- [ ] All features work offline
- [ ] No "connection required" errors

**Rationale:**
Mobile players often have unreliable connectivity.

---

### Security

#### NFR-011: Save Data

**Priority:** Could Have

**Description:**
For MVP, local save data is not encrypted (acceptable risk for offline single-player).

**Acceptance Criteria:**
- [ ] Save data stored locally
- [ ] Note: Consider encryption for future online features

**Rationale:**
Offline MVP has low security risk; encryption adds complexity.

---

## Epics

Epics are logical groupings of related functionality that will be broken down into user stories during sprint planning (Phase 4).

---

### EPIC-001: Combat Core

**Description:**
Core tactical combat system with grid movement, pincer/chain mechanics, damage calculation, elements, skills, and turn structure.

**Functional Requirements:**
- FR-001: Grid-Based Movement
- FR-002: Pincer Attack System
- FR-003: Damage Calculation
- FR-004: Chain Attack System
- FR-005: Elemental System
- FR-006: Character Skills
- FR-007: Turn System

**Story Count Estimate:** 10-14

**Priority:** Must Have

**Business Value:**
Core gameplay loop - this is the primary differentiator from competitors and the reason players will engage with the game.

---

### EPIC-002: Run System

**Description:**
Roguelite run structure with procedural maps, node types (combat, healing, events, bosses), and reward handling.

**Functional Requirements:**
- FR-008: Node-Based Map
- FR-009: Procedural Map Generation
- FR-010: Combat Nodes
- FR-011: Healing Nodes
- FR-012: Event Nodes
- FR-013: Boss Encounters
- FR-014: Run Completion Rewards
- FR-015: Run Failure Handling

**Story Count Estimate:** 8-12

**Priority:** Must Have

**Business Value:**
Provides replayability and session structure - keeps players coming back for "one more run."

---

### EPIC-003: Progression

**Description:**
Run-based unit progression with stats, leveling, and post-combat draft upgrade system.

**Functional Requirements:**
- FR-016: Character Stats
- FR-017: Run-Based Leveling
- FR-018: Post-Combat Draft System

**Story Count Estimate:** 4-6

**Priority:** Must Have

**Business Value:**
Creates meaningful choices and engagement within each run - the "hook" that makes each run feel different.

---

### EPIC-004: Gacha & Collection

**Description:**
Character summoning system with banners, pull rates, rarity tiers, duplicate handling, and team building.

**Functional Requirements:**
- FR-019: Gacha Banners
- FR-020: Pull Rates & Rarity
- FR-021: Character Collection & Duplicates
- FR-022: Team Building

**Story Count Estimate:** 6-8

**Priority:** Must Have

**Business Value:**
Primary monetization driver and long-term player investment - the "collection" aspect that keeps players engaged for months.

---

### EPIC-005: Core UI

**Description:**
Main menu, unit collection screen, run selection, combat UI, gacha interface, and currency display.

**Functional Requirements:**
- FR-023: Main Menu
- FR-024: Unit Collection Screen
- FR-025: Run Selection Screen
- FR-026: Combat UI
- FR-027: Gacha Interface
- FR-028: Currency Display

**Story Count Estimate:** 6-10

**Priority:** Must Have

**Business Value:**
Player experience foundation - intuitive UI reduces friction and improves retention.

---

## User Stories (High-Level)

Detailed user stories will be created during sprint planning (Phase 4).

---

## User Personas

### Persona 1: The Gacha Enthusiast

- **Age:** 25-40
- **Platform:** Mobile-first
- **Games:** Arknights, Fire Emblem Heroes, Genshin Impact
- **Motivations:** Collection, pulls, unit investment, "waifu/husbando" collecting
- **Pain Points:** Limited currency, duplicate pulls, power creep
- **Goals:** Build diverse collection, pull high-rarity units, invest in favorites

### Persona 2: The Tactical Strategist

- **Age:** 25-40
- **Platform:** Mobile and PC
- **Games:** Fire Emblem, Into the Breach, Slay the Spire
- **Motivations:** Deep gameplay, positioning mastery, theorycrafting, optimization
- **Pain Points:** Shallow combat, repetitive runs, lack of meaningful choices
- **Goals:** Master combat system, optimize team builds, achieve high win rates

---

## User Flows

### Flow 1: First Run

1. Open app -> Main Menu
2. Tap "Run" -> Team selection (use default preset)
3. Start run -> Node map appears
4. Select combat node -> Enter combat
5. Complete combat -> Draft upgrade screen
6. Select unit to upgrade -> Continue
7. Continue through nodes (combat, healing, events)
8. Reach boss -> Boss fight
9. Win/lose -> Rewards/defeat screen
10. Return to main menu

### Flow 2: Gacha Pull

1. Main Menu -> Tap "Gacha"
2. Select banner -> Review rates and cost
3. Tap pull button -> Animation plays
4. View results -> New unit or charges added
5. Return to collection or pull again

### Flow 3: Team Building

1. Main Menu -> Tap "Team"
2. Select preset slot
3. Add/remove units from collection
4. Save preset
5. Return to main menu

---

## Dependencies

### Internal Dependencies

- Combat system (EPIC-001) required before run system (EPIC-002) can function
- Unit data model required for gacha (EPIC-004), team building, and combat
- Save system required for collection/currency persistence
- Core UI (EPIC-005) integrates all other epics

### External Dependencies

- Godot Engine 4.x
- Asset packs for art and audio
- AI tools for content generation

---

## Assumptions

- Players will find combat intuitive without extensive tutorials
- The gacha economy will be balanced enough at launch to be fair and engaging
- Godot can handle mobile performance requirements for tactical grid combat
- Marketing will be primarily organic/community-driven (no paid user acquisition budget)
- AI tools will continue improving to help fill art and audio skill gaps
- The target audience exists and is reachable through organic channels
- The scope is achievable solo within a reasonable timeline

---

## Out of Scope (v1.0)

- Job/class system
- Gear/equipment system
- Artifacts/modifiers during runs
- Meta progression (permanent unlocks between runs)
- Story/campaign mode
- Multiplayer / PvP
- Guilds
- Events
- Battle pass
- Arena / Rankings
- Cloud saves
- Online features

---

## Open Questions

1. **Event Node Types:** Specific event types and outcomes TBD
2. **Gacha Pull Rates:** Exact percentages for 3/4/5-star pulls TBD
3. **Launch Unit Roster:** Number of units at launch TBD (recommend 8-12)
4. **Diamond Acquisition:** How players earn premium currency TBD
5. **Unit Balance:** Specific stat values and skill tuning TBD
6. **Boss Mechanics:** Unique boss behaviors TBD
7. **Enemy AI:** Movement and targeting behavior TBD

## Resolved Questions

- **Grid Size:** 6 columns × 8 rows
- **Starting Units:** 6 units for development (new player experience TBD)
- **Skill Scaling:** Damage improves with level; new AOE patterns can unlock (see FR-006 for pattern types)

---

## Approval & Sign-off

### Stakeholders

- **rboniface (Solo Developer)** - Product Owner, Engineering Lead, Design Lead, QA Lead

### Approval Status

- [ ] Product Owner
- [ ] Engineering Lead
- [ ] Design Lead
- [ ] QA Lead

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-03-09 | rboniface | Initial PRD |

---

## Next Steps

### Phase 3: Architecture

Run `/architecture` to create system architecture based on these requirements.

The architecture will address:
- All functional requirements (FRs)
- All non-functional requirements (NFRs)
- Technical stack decisions
- Data models and APIs
- System components

### Phase 4: Sprint Planning

After architecture is complete, run `/sprint-planning` to:
- Break epics into detailed user stories
- Estimate story complexity
- Plan sprint iterations
- Begin implementation

---

**This document was created using BMAD Method v6 - Phase 2 (Planning)**

*To continue: Run `/workflow-status` to see your progress and next recommended workflow.*

---

## Appendix A: Requirements Traceability Matrix

| Epic ID | Epic Name | Functional Requirements | Story Count (Est.) |
|---------|-----------|-------------------------|-------------------|
| EPIC-001 | Combat Core | FR-001, FR-002, FR-003, FR-004, FR-005, FR-006, FR-007 | 10-14 |
| EPIC-002 | Run System | FR-008, FR-009, FR-010, FR-011, FR-012, FR-013, FR-014, FR-015 | 8-12 |
| EPIC-003 | Progression | FR-016, FR-017, FR-018 | 4-6 |
| EPIC-004 | Gacha & Collection | FR-019, FR-020, FR-021, FR-022 | 6-8 |
| EPIC-005 | Core UI | FR-023, FR-024, FR-025, FR-026, FR-027, FR-028 | 6-10 |

**Total Estimated Stories:** 34-50

---

## Appendix B: Prioritization Details

### Functional Requirements by Priority

| Priority | Count | Percentage |
|----------|-------|------------|
| Must Have | 27 | 100% |
| Should Have | 0 | 0% |
| Could Have | 0 | 0% |

### Non-Functional Requirements by Priority

| Priority | Count | Percentage |
|----------|-------|------------|
| Must Have | 10 | 91% |
| Could Have | 1 | 9% |

**Note:** All functional requirements are Must Have for MVP. Future phases may introduce Should/Could priorities for enhancements.
