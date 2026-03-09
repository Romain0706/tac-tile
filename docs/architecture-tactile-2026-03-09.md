# System Architecture: tac'tile

**Date:** 2026-03-09
**Architect:** rboniface
**Version:** 1.0
**Project Type:** Game
**Project Level:** 3 (Complex)
**Status:** Draft

---

## Document Overview

This document defines the system architecture for tac'tile, a roguelite tactical RPG built in Godot 4.x. It provides the technical blueprint for implementation, addressing all functional and non-functional requirements from the PRD.

**Related Documents:**
- Product Requirements Document: docs/prd-tactile-2026-03-09.md
- Product Brief: docs/product-brief-tactile-2026-03-08.md

---

## Executive Summary

tac'tile is a mobile-first roguelite tactical RPG using Godot 4.x as the game engine. The architecture follows Godot's idiomatic scene-based pattern with autoload singletons for global systems. All game data persists locally using Godot Resources (.tres), enabling full offline play. The combat system is encapsulated as a self-contained scene with child nodes for grid, units, and turn management, ensuring clean separation and testability.

---

## Architectural Drivers

These requirements heavily influence architectural decisions:

| Priority | NFR | Requirement | Architectural Impact |
|----------|-----|-------------|---------------------|
| Critical | NFR-001 | 60 FPS during combat | Efficient game loop, no blocking operations, object pooling |
| Critical | NFR-003 | <100ms touch response | Frame-perfect input handling, immediate visual feedback |
| Critical | NFR-010 | Full offline play | No server dependency, all data local |
| High | NFR-009 | Crash recovery | State serialization at each node entry |
| High | NFR-005 | 2GB RAM, mobile | Memory management, asset streaming, texture atlases |
| Medium | NFR-002 | <5s load, <3s transitions | Async loading, progress indicators, scene preloading |

---

## System Overview

### High-Level Architecture

tac'tile follows a **scene-based architecture** with autoload singletons for cross-cutting concerns. The game is organized into distinct scene hierarchies for each major feature area (combat, run map, menus), with global managers accessible via autoloads.

**Core Principles:**
1. **Scene Encapsulation**: Each major feature (combat, gacha, team building) is a self-contained scene
2. **Singleton Managers**: Global state and cross-scene systems use autoload singletons
3. **Resource-Based Data**: All game data (units, skills, player progress) stored as Godot Resources
4. **Signal-Driven Communication**: Loose coupling between systems via Godot signals
5. **State Machine Patterns**: Clear state management for runs, combat turns, UI flows

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        MAIN SCENE                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │  MainMenu   │  │   RunMap    │  │   Combat    │             │
│  │   Scene     │  │   Scene     │  │   Scene     │             │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘             │
│         │                │                │                     │
│  ┌──────▼──────┐  ┌──────▼──────┐  ┌──────▼──────┐             │
│  │ TeamBuilder │  │ NodeEvents  │  │ CombatGrid  │             │
│  │   (sub)     │  │   (sub)     │  │ Units       │             │
│  │ GachaUI     │  │ Healing     │  │ TurnManager │             │
│  │ Collection  │  │ Boss        │  │ SkillSystem │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     AUTOLOAD SINGLETONS                         │
│  ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────┐       │
│  │GameManager│ │ SaveManager│ │UnitDatabase│ │RunState  │       │
│  └───────────┘ └───────────┘ └───────────┘ └───────────┘       │
│  ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────┐       │
│  │AudioManager│ │UIManager  │ │SceneManager│ │Config     │       │
│  └───────────┘ └───────────┘ └───────────┘ └───────────┘       │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      DATA LAYER (Resources)                     │
│  ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────┐       │
│  │PlayerData │ │ UnitData  │ │ SkillData │ │RunSaveData│       │
│  │  (.tres)  │ │  (.tres)  │  │  (.tres)  │  (.tres)  │       │
│  └───────────┘ └───────────┘ └───────────┘ └───────────┘       │
└─────────────────────────────────────────────────────────────────┘
```

### Architectural Pattern

**Pattern:** Scene-Based with Autoload Singletons

**Rationale:**
- **Idiomatic Godot**: Follows Godot's recommended patterns and best practices
- **Encapsulation**: Each scene is self-contained, easy to test in isolation
- **Scalability**: New features add new scenes without affecting existing ones
- **Solo Developer Friendly**: Simple mental model, easy to navigate and maintain
- **Performance**: Scenes can be preloaded/cached, minimal overhead

---

## Technology Stack

### Game Engine

**Choice:** Godot 4.x (GDScript primary, C# optional for performance-critical code)

**Rationale:**
- Free and open source (no licensing costs)
- Excellent 2D performance with dedicated 2D engine
- Native mobile export (iOS, Android)
- Built-in resource system for data management
- Active community and extensive documentation
- Lightweight compared to Unity/Unreal

**Trade-offs:**
- Smaller ecosystem than Unity
- GDScript less performant than C++ (mitigated by C# option)
- Mobile export requires additional setup

### Language

**Choice:** GDScript 2.0 (primary), with optional C# for combat math

**Rationale:**
- GDScript optimized for Godot, tight engine integration
- Dynamically typed for rapid iteration (static typing optional)
- C# available for damage calculation hotspots if needed
- Solo dev benefits from GDScript's simplicity

**Trade-offs:**
- GDScript skills less transferable than C#
- Can mix both if performance bottlenecks identified

### Data Format

**Choice:** Godot Resources (.tres/.res)

**Rationale:**
- Native serialization, no parsing overhead
- Type-safe with custom Resource classes
- Hot-reload in editor for iteration
- Binary (.res) or text (.tres) format options
- Built-in reference handling

**Trade-offs:**
- Godot-specific format (not human-readable in binary)
- Version migration handled by Godot

### Version Control

**Choice:** Git with GitHub

**Rationale:**
- Industry standard, free for public/private repos
- GitHub Actions for CI/CD
- LFS support for large binary assets

### Asset Pipeline

**Choice:** AI generation + asset packs + Aseprite for pixel art

**Rationale:**
- Per constraints: no art skills, using AI and asset packs
- Aseprite for UI elements and any custom pixel art
- Godot's texture atlas system for sprite packing

### Development & Deployment

| Category | Tool | Rationale |
|----------|------|-----------|
| IDE | VS Code + Godot extension | Free, good GDScript support |
| Testing | GUT (Godot Unit Test) | Native Godot testing framework |
| CI/CD | GitHub Actions | Free for public repos, mobile builds |
| Profiling | Godot Profiler | Built-in, frame-perfect analysis |
| Mobile Export | Godot Export Templates | Native iOS/Android export |

---

## System Components

### Component: GameManager (Autoload)

**Purpose:** Global game state and coordination

**Responsibilities:**
- Track current game phase (menu, run, combat)
- Manage player resources (gold, diamonds)
- Coordinate between other autoloads
- Handle app lifecycle (pause, resume, quit)

**Interfaces:**
- Signals: `run_started`, `run_ended`, `resources_changed`
- Methods: `get_currency(type)`, `spend_currency(type, amount)`

**Dependencies:** SaveManager, UIManager

**FRs Addressed:** FR-028 (Currency Display)

---

### Component: SaveManager (Autoload)

**Purpose:** Persistent data storage and retrieval

**Responsibilities:**
- Save/load player data to local storage
- Auto-save at checkpoints (node entry, combat end)
- Handle crash recovery (resume state)
- Validate save data integrity

**Interfaces:**
- Methods: `save_player_data()`, `load_player_data()`, `save_run_state()`, `load_run_state()`
- Signals: `save_completed`, `load_completed`

**Dependencies:** None

**FRs Addressed:** FR-008 (Local Save), FR-009 (Crash Recovery)

---

### Component: UnitDatabase (Autoload)

**Purpose:** Central repository of all unit definitions

**Responsibilities:**
- Load unit data from Resource files
- Provide unit lookup by ID
- Store base stats, skills, elements, rarity

**Interfaces:**
- Methods: `get_unit(id)`, `get_all_units()`, `get_units_by_element(element)`

**Dependencies:** UnitData resources

**FRs Addressed:** FR-016 (Character Stats), FR-020 (Pull Rates & Rarity)

---

### Component: RunState (Autoload)

**Purpose:** Active run state management

**Responsibilities:**
- Track current run progress (node position, completed nodes)
- Manage run-specific unit levels and stats
- Store accumulated loot/rewards
- Generate procedural map

**Interfaces:**
- Methods: `start_run(team_preset)`, `advance_to_node(node_id)`, `end_run(victory)`
- Signals: `node_entered`, `run_ended`

**Dependencies:** UnitDatabase, GameManager

**FRs Addressed:** FR-008 to FR-015 (Run System), FR-017 (Run-Based Leveling)

---

### Component: CombatScene (Scene)

**Purpose:** Self-contained tactical combat system

**Responsibilities:**
- Manage 6x8 combat grid
- Handle unit placement and movement
- Execute pincer/chain attack resolution
- Calculate damage with formulas
- Manage turn order and phases
- Apply skills, elements, status effects

**Child Nodes:**
- `GridRenderer` - Visual grid and positioning
- `UnitLayer` - Unit sprites and animations
- `TurnManager` - Turn phases and resolution order
- `DamageCalculator` - Formula implementation
- `SkillExecutor` - Skill activation and AOE
- `InputHandler` - Drag controls and timer

**Interfaces:**
- Methods: `initiate_combat(enemy_data)`, `end_combat()`
- Signals: `combat_victory`, `combat_defeat`, `turn_completed`

**Dependencies:** RunState, UnitDatabase

**FRs Addressed:** FR-001 to FR-007 (Combat System)

---

### Component: RunMapScene (Scene)

**Purpose:** Node-based run progression UI

**Responsibilities:**
- Display procedural map with nodes
- Handle node selection
- Transition to combat/event/boss scenes
- Show run progress

**Interfaces:**
- Methods: `display_map(map_data)`, `select_node(node_id)`
- Signals: `node_selected`

**Dependencies:** RunState

**FRs Addressed:** FR-008 (Node-Based Map), FR-009 (Procedural Generation)

---

### Component: GachaScene (Scene)

**Purpose:** Character summoning interface

**Responsibilities:**
- Display available banners
- Handle pull purchases
- Execute pull animation
- Award units/charges
- Display results

**Interfaces:**
- Methods: `pull_banner(banner_id, count)`
- Signals: `pull_completed`

**Dependencies:** GameManager (currency), UnitDatabase, SaveManager

**FRs Addressed:** FR-019 to FR-021 (Gacha & Collection)

---

### Component: TeamBuilderScene (Scene)

**Purpose:** Team composition management

**Responsibilities:**
- Display owned units
- Create/edit/delete team presets
- Enforce 6-unit limit
- Save preset selections

**Interfaces:**
- Methods: `load_preset(id)`, `save_preset(id, units)`

**Dependencies:** SaveManager, UnitDatabase

**FRs Addressed:** FR-022 (Team Building)

---

### Component: UIManager (Autoload)

**Purpose:** UI coordination and transitions

**Responsibilities:**
- Manage scene transitions
- Display modal dialogs
- Show toast notifications
- Handle back button behavior

**Interfaces:**
- Methods: `change_scene(path)`, `show_modal(scene)`, `show_toast(message)`

**Dependencies:** None

**FRs Addressed:** NFR-002 (Load Times), NFR-006 (Touch Interface)

---

### Component: AudioManager (Autoload)

**Purpose:** Sound and music management

**Responsibilities:**
- Play background music per scene
- Trigger sound effects
- Handle volume settings
- Support audio pooling

**Interfaces:**
- Methods: `play_music(track)`, `play_sfx(sound_id)`, `set_volume(type, value)`

**Dependencies:** None

---

## Data Architecture

### Data Model

```
┌─────────────────────────────────────────────────────────────────┐
│                        CORE ENTITIES                            │
└─────────────────────────────────────────────────────────────────┘

PlayerData (Resource)
├── currencies: Dictionary
│   ├── gold: int
│   └── diamonds: int
├── owned_units: Array[OwnedUnit]
├── team_presets: Array[TeamPreset]
├── settings: GameSettings
└── tutorial_completed: bool

OwnedUnit (Resource)
├── unit_id: String (references UnitData)
├── rarity: int (3, 4, or 5)
├── charges: int
└── obtained_date: int (unix timestamp)

TeamPreset (Resource)
├── id: String
├── name: String
├── unit_ids: Array[String] (6 slots, can be empty)
└── created_date: int

UnitData (Resource) - Static definition
├── id: String
├── display_name: String
├── element: Enum (FIRE, ICE, LIGHTNING, LIGHT, DARK)
├── weapon_type: Enum (MELEE, DISTANCE, REACH, MAGIC)
├── rarity: int (3, 4, or 5)
├── base_stats: UnitStats
│   ├── hp: int
│   ├── atk: int
│   ├── def: int
│   ├── matk: int
│   └── mdef: int
├── pincer_skill: SkillData (optional)
├── chain_skill: SkillData (optional)
└── passive_skill: SkillData

SkillData (Resource)
├── id: String
├── display_name: String
├── description: String
├── skill_type: Enum (PINCER, CHAIN, PASSIVE)
├── aoe_pattern: Enum (NONE, ADJACENT, AREA_1, CROSS_2, CHAIN, etc.)
├── effect_type: Enum (DAMAGE, HEAL, BUFF, DEBUFF)
├── base_power: int (1, 2, 3 for basic/advanced/ultimate)
├── element: Enum (or NONE for physical)
└── level_scaling: Array[float] (multiplier per level 1-5)

RunSaveData (Resource)
├── active: bool
├── current_node_id: String
├── map_seed: int
├── nodes: Array[NodeData]
├── team: Array[RunUnit]
├── accumulated_rewards: Dictionary
└── run_start_time: int

RunUnit (Resource) - Instance during run
├── unit_id: String
├── level: int (1-5)
├── current_hp: int
├── current_stats: UnitStats (modified by level)
└── is_alive: bool

NodeData (Resource)
├── id: String
├── type: Enum (COMBAT, HEALING, EVENT, BOSS)
├── position: Vector2
├── connections: Array[String] (node IDs)
├── completed: bool
└── encounter_data: Dictionary (enemy configs, event ID, etc.)

EnemyData (Resource)
├── id: String
├── display_name: String
├── element: Enum
├── weapon_type: Enum
├── stats: UnitStats
│   └── move: int (movement range)
├── skills: Array[SkillData]
└── ai_behavior: Enum (AGGRESSIVE, DEFENSIVE, SUPPORT)
```

### Database Design

No traditional database - all data stored as Godot Resources:

**Static Data (Read-only, bundled with game):**
- `data/units/` - UnitData resources (one per unit)
- `data/skills/` - SkillData resources
- `data/enemies/` - EnemyData resources
- `data/events/` - EventData resources

**Dynamic Data (User-generated, saved to device):**
- `user://player_data.tres` - PlayerData resource
- `user://run_save.tres` - RunSaveData resource (for crash recovery)
- `user://settings.tres` - GameSettings resource

**File Structure:**
```
res://
├── data/
│   ├── units/
│   │   ├── unit_fire_warrior.tres
│   │   ├── unit_ice_mage.tres
│   │   └── ...
│   ├── skills/
│   ├── enemies/
│   └── events/
├── scenes/
│   ├── combat/
│   ├── run/
│   ├── menu/
│   └── gacha/
├── scripts/
│   ├── autoload/
│   ├── combat/
│   ├── data/
│   └── ui/
├── resources/
│   └── themes/
└── assets/
    ├── sprites/
    ├── audio/
    └── fonts/

user://
├── player_data.tres
├── run_save.tres
└── settings.tres
```

### Data Flow

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Game Start  │────▶│ SaveManager  │────▶│ Load Player  │
└──────────────┘     │ .load_data() │     │    Data      │
                     └──────────────┘     └──────────────┘
                                                 │
                     ┌──────────────┐            ▼
                     │   RunState   │     ┌──────────────┐
                     │  (in memory) │◀────│   GameManager│
                     └──────────────┘     │   (autoload) │
                           │              └──────────────┘
                           ▼                     │
                     ┌──────────────┐            │
                     │ Combat Scene │            │
                     │ (reads units)│            │
                     └──────────────┘            │
                           │                     │
                           ▼                     ▼
                     ┌──────────────┐     ┌──────────────┐
                     │ Run Ends     │────▶│ SaveManager  │
                     │ (victory/loss)│    │ .save_data() │
                     └──────────────┘     └──────────────┘
                                                 │
                                                 ▼
                                          ┌──────────────┐
                                          │ user://      │
                                          │ player_data  │
                                          └──────────────┘
```

**Key Data Flows:**

1. **Game Start:** SaveManager loads PlayerData from user://
2. **Run Start:** RunState initializes with team preset, generates map
3. **Combat:** CombatScene reads from RunState, modifies RunUnits
4. **Node Complete:** SaveManager saves RunSaveData (crash recovery)
5. **Run End:** Rewards merged into PlayerData, RunSaveData cleared
6. **Gacha Pull:** New OwnedUnit added to PlayerData, saved immediately

---

## API Design

As a local game, there are no REST APIs. Instead, the "API" consists of:

### Scene Interfaces

Each scene exposes a public interface for initialization:

```gdscript
# CombatScene.gd
func initiate_combat(enemies: Array[EnemyData], run_units: Array[RunUnit]) -> void
func end_combat() -> Dictionary  # Returns {victory: bool, rewards: Dictionary}

# RunMapScene.gd
func display_map(nodes: Array[NodeData], current_position: String) -> void

# GachaScene.gd
func pull_banner(banner_id: String, count: int) -> Array[OwnedUnit]

# TeamBuilderScene.gd
func load_preset(preset_id: String) -> void
func save_preset(preset_id: String, unit_ids: Array[String]) -> bool
```

### Autoload Interfaces

```gdscript
# GameManager.gd
signal resources_changed(currency_type: String, new_amount: int)
signal run_started()
signal run_ended(victory: bool)

func get_currency(type: String) -> int
func spend_currency(type: String, amount: int) -> bool
func add_currency(type: String, amount: int) -> void

# SaveManager.gd
signal save_completed()
signal load_completed()

func save_player_data() -> void
func load_player_data() -> PlayerData
func save_run_state() -> void
func load_run_state() -> RunSaveData
func has_crash_recovery() -> bool

# UnitDatabase.gd
func get_unit(unit_id: String) -> UnitData
func get_all_units() -> Array[UnitData]
func get_units_by_rarity(rarity: int) -> Array[UnitData]

# RunState.gd
signal node_entered(node: NodeData)
signal node_completed(node: NodeData)

func start_run(team_preset: TeamPreset) -> void
func get_current_map() -> Array[NodeData]
func advance_to_node(node_id: String) -> void
func get_run_units() -> Array[RunUnit]
func end_run(victory: bool) -> Dictionary
```

### Signal-Based Communication

Key signals for inter-system communication:

| Signal | Emitter | Consumer | Purpose |
|--------|---------|----------|---------|
| `combat_victory` | CombatScene | RunState | Trigger post-combat draft |
| `combat_defeat` | CombatScene | RunState | End run with failure |
| `node_selected` | RunMapScene | RunState | Advance run position |
| `pull_completed` | GachaScene | SaveManager | Save new units |
| `resources_changed` | GameManager | UI | Update currency display |
| `unit_died` | CombatScene | CombatScene | Check lose condition |

---

## Non-Functional Requirements Coverage

### NFR-001: Frame Rate (60 FPS)

**Requirement:** Game maintains 60 FPS during combat and UI navigation.

**Architecture Solution:**
- **Object Pooling:** Reuse unit sprites, particle effects, UI elements
- **Efficient Rendering:** Use Sprite2D with texture atlases, avoid overdraw
- **No Frame-Blocking:** All file I/O async, damage calculations cached
- **Godot 4.x Vulkan:** Leverage modern rendering pipeline
- **Profile Critical Paths:** Combat resolution logic benchmarked

**Implementation Notes:**
- Pre-instantiate unit nodes at combat start (not during turns)
- Use `@onready` for node references, cache frequently accessed values
- Batch UI updates, avoid per-frame string operations
- Limit particle count during chain attacks

**Validation:**
- Godot Profiler shows consistent 16.67ms frame time
- No frame drops during 6-unit chain attack with skills
- Test on minimum spec device (2GB RAM)

---

### NFR-002: Load Times

**Requirement:** Initial game load < 5 seconds, scene transitions < 3 seconds.

**Architecture Solution:**
- **Async Loading:** Use `ResourceLoader.load_threaded()` for scenes
- **Progress Indicators:** Show loading bar during transitions
- **Resource Preloading:** Cache common resources at game start
- **Minimal Initial Load:** Load only MainMenu resources on startup
- **Lazy Loading:** Load unit sprites on demand, cache after first use

**Implementation Notes:**
- MainMenu scene loads in background while splash screen shows
- Combat scene preloads during run map navigation
- Use background thread for SaveManager operations

**Validation:**
- Measure cold start on mid-range device
- Scene transition timing logged in debug builds

---

### NFR-003: Touch Responsiveness

**Requirement:** Touch input response < 100ms for all interactions.

**Architecture Solution:**
- **Frame-Perfect Input:** Process drag input in `_input()` or `_unhandled_input()`
- **Immediate Visual Feedback:** Highlight draggable units on touch start
- **No Input Queueing:** Process input immediately, discard stale events
- **Touch Target Sizing:** All interactive elements ≥44px (per NFR-006)

**Implementation Notes:**
- Use `_input()` for combat drag, `_gui_input()` for UI buttons
- Visual feedback within same frame as touch detection
- Debounce rapid taps on buttons

**Validation:**
- Input-to-visual-response measured in frames (target: <6 frames at 60fps)
- Usability testing confirms no perceived lag

---

### NFR-004: OS Support

**Requirement:** iOS 13+ and Android 8.0+ (64-bit only).

**Architecture Solution:**
- **Godot Export Templates:** Official templates support both platforms
- **64-bit Only:** Configure export for arm64 only
- **Minimum Version Flags:** Set in export presets
- **Graceful Degradation:** Check device capabilities at runtime

**Implementation Notes:**
- Test on iOS 13 simulator and Android 8.0 emulator
- Handle notch/safe areas via Godot's DisplayServer

**Validation:**
- Successful install and launch on minimum OS devices
- Store submission validates compatibility

---

### NFR-005: Hardware

**Requirement:** Minimum 2GB RAM, supports phones and tablets, portrait only.

**Architecture Solution:**
- **Memory Budget:** Target <500MB RAM usage
- **Texture Atlases:** Reduce draw calls and memory fragmentation
- **Portrait UI:** All scenes designed for 9:16 aspect ratio
- **Responsive Layout:** UI anchors to edges, scales for tablets
- **Asset Streaming:** Load/unload scene assets on demand

**Implementation Notes:**
- Use Godot's texture importer with appropriate compression (ETC2/ASTC)
- Test on low-end device with 2GB RAM
- Monitor memory in profiler during extended play

**Validation:**
- No out-of-memory crashes on 2GB device
- UI readable on 4" phone and 10" tablet

---

### NFR-006: Touch Interface

**Requirement:** All interactive elements have minimum 44px touch targets with clear visual feedback.

**Architecture Solution:**
- **TouchTarget Component:** Reusable scene with minimum size enforcement
- **Visual Feedback:** Scale/color change on press for all buttons
- **Drag Feedback:** Unit highlights, path preview during drag
- **Touch Layer:** Separate input handling for UI vs. game world

**Implementation Notes:**
- Create ButtonTemplate scene with consistent styling and sizing
- Use Theme resources for UI consistency

**Validation:**
- All buttons/interactive elements audited for size
- Usability testing confirms no misclicks

---

### NFR-007: Readability

**Requirement:** Text readable on mobile screens (minimum 14pt), high contrast for combat info.

**Architecture Solution:**
- **Font Sizes:** Body text 14pt minimum, headers 18pt+
- **High Contrast:** HP bars, stats use distinct colors
- **Scalable Fonts:** Support system font scaling if implemented later
- **Combat Legibility:** Unit stats readable during action

**Implementation Notes:**
- Use bitmap fonts for pixel-perfect rendering at target sizes
- Test on small screen (4" phone)

**Validation:**
- All text readable on minimum target device
- Combat stats visible during animations

---

### NFR-008: Local Save

**Requirement:** Player data persists between sessions and survives app close.

**Architecture Solution:**
- **Godot Resource Serialization:** Native .tres format
- **Auto-Save Points:** After every meaningful action (pull, run end, team save)
- **Atomic Writes:** Write to temp file, then rename (prevent corruption)
- **Version Field:** Support future migration

**Implementation Notes:**
- Save to `user://` directory (OS-appropriate location)
- Include save version number for future compatibility

**Validation:**
- Force-close app, relaunch, data persists
- No data loss after 100 save/load cycles

---

### NFR-009: Crash Recovery

**Requirement:** If game crashes during run, player can resume from current node start.

**Architecture Solution:**
- **RunSaveData:** Serialized at each node entry
- **Resume Detection:** Check for existing RunSaveData on game start
- **State Restoration:** Rebuild run state from saved data
- **Graceful Recovery:** Offer "Continue Run" or "Abandon Run" choice

**Implementation Notes:**
- Save before entering any node (combat, event, healing, boss)
- Include full RunUnits state (HP, levels)
- Clear RunSaveData on run completion or player abandon

**Validation:**
- Simulate crash (kill process), relaunch, resume works
- No progress lost beyond current node

---

### NFR-010: Offline Play

**Requirement:** Entire game playable without internet connection.

**Architecture Solution:**
- **No Network Calls:** Zero HTTP requests in game loop
- **Local Data Only:** All units, enemies, events bundled with game
- **No Authentication:** No login required
- **Future-Proof:** Architecture supports adding online features later without refactor

**Implementation Notes:**
- Use `res://` for static data, `user://` for player data
- No analytics/ads in MVP (or use local-only alternatives)

**Validation:**
- Airplane mode test: full game playable
- No network-related errors in logs

---

### NFR-011: Save Data Security

**Requirement:** Local save data not encrypted for MVP (acceptable risk).

**Architecture Solution:**
- **Accept Risk:** Single-player, offline game has low security requirements
- **No Sensitive Data:** No personal information, payment data stored
- **Future Option:** Architecture supports adding encryption layer

**Implementation Notes:**
- Document as known limitation
- If gacha fraud becomes issue, add simple XOR obfuscation

**Validation:**
- Risk assessment documented and accepted

---

## Security Architecture

### Authentication

**Not Applicable (MVP):** No user accounts or authentication required.

**Future Consideration:**
- Optional cloud save would require account system
- Consider Godot's HTTPClient with OAuth if implemented

### Authorization

**Not Applicable:** Single-player, local-only game. No multi-user scenarios.

### Data Encryption

**At Rest:** Not encrypted (per NFR-011)
**In Transit:** Not applicable (no network traffic)

### Security Best Practices

| Practice | Implementation |
|----------|---------------|
| Input Validation | Clamp all numeric inputs, validate unit IDs |
| Integer Overflow | Use 64-bit ints for currencies |
| Save Integrity | Checksum on load (optional for MVP) |
| Memory Safety | Godot handles, no manual memory management |

---

## Scalability & Performance

### Scaling Strategy

**Not Applicable (MVP):** Single-player, local game. No server scaling needed.

**Future Consideration:**
- Cloud saves would require backend scaling
- Design SaveManager to support remote storage

### Performance Optimization

| Area | Strategy |
|------|----------|
| Combat Resolution | Cache damage formulas, batch skill effects |
| Rendering | Texture atlases, limit draw calls, use TileMap for grid |
| Memory | Object pooling, unload unused resources |
| Input | Process in `_input()`, avoid per-frame polling |
| Save/Load | Async operations, background threads |

### Caching Strategy

| Cache Type | Content | Invalidation |
|------------|---------|--------------|
| Resource Cache | Loaded units, skills | Never (static data) |
| Scene Cache | Visited scenes | On scene change |
| Calculation Cache | Damage results | Per turn |

### Load Balancing

**Not Applicable:** No server infrastructure.

---

## Reliability & Availability

### High Availability Design

**Not Applicable:** Local game always "available" when device is on.

### Disaster Recovery

| Scenario | Recovery |
|----------|----------|
| App Crash | Resume from RunSaveData (NFR-009) |
| Save Corruption | Backup save on successful load, restore if corrupted |
| Device Loss | No recovery (local-only MVP) |

### Backup Strategy

**MVP:** No cloud backup.

**Implementation:**
- Keep last known-good save in memory
- On load failure, offer to restore from backup

### Monitoring & Alerting

**MVP:** Local logging only.

**Implementation:**
- Log errors to `user://logs/`
- Optional: Export logs for debugging

---

## Integration Architecture

### External Integrations

**MVP:** None. Fully offline.

**Future Considerations:**
- Cloud save (Firebase, PlayFab, custom backend)
- Analytics (local-first alternatives like PostHog self-hosted)
- Ads (if monetization changes)
- IAP (if premium currency becomes real-money)

### Internal Integrations

All internal communication via:
- **Direct Method Calls:** For synchronous operations
- **Godot Signals:** For decoupled, event-driven communication
- **Resource References:** For shared data access

---

## Development Architecture

### Code Organization

```
tactile/
├── project.godot
├── export_presets.cfg
├── .github/
│   └── workflows/
│       └── build.yml
├── assets/
│   ├── sprites/
│   │   ├── units/
│   │   ├── ui/
│   │   └── effects/
│   ├── audio/
│   │   ├── music/
│   │   └── sfx/
│   └── fonts/
├── data/
│   ├── units/
│   ├── skills/
│   ├── enemies/
│   └── events/
├── scenes/
│   ├── main.tscn
│   ├── combat/
│   │   ├── combat.tscn
│   │   ├── grid_renderer.tscn
│   │   └── unit_sprite.tscn
│   ├── run/
│   │   ├── run_map.tscn
│   │   └── node_event.tscn
│   ├── menu/
│   │   ├── main_menu.tscn
│   │   ├── team_builder.tscn
│   │   └── collection.tscn
│   └── gacha/
│       └── gacha.tscn
├── scripts/
│   ├── autoload/
│   │   ├── game_manager.gd
│   │   ├── save_manager.gd
│   │   ├── unit_database.gd
│   │   ├── run_state.gd
│   │   ├── ui_manager.gd
│   │   └── audio_manager.gd
│   ├── combat/
│   │   ├── combat_scene.gd
│   │   ├── grid_system.gd
│   │   ├── turn_manager.gd
│   │   ├── damage_calculator.gd
│   │   ├── skill_executor.gd
│   │   └── input_handler.gd
│   ├── run/
│   │   ├── run_map_scene.gd
│   │   ├── map_generator.gd
│   │   └── node_handler.gd
│   ├── data/
│   │   ├── player_data.gd
│   │   ├── unit_data.gd
│   │   ├── skill_data.gd
│   │   └── run_save_data.gd
│   └── ui/
│       ├── components/
│       └── screens/
└── tests/
    ├── test_combat/
    ├── test_damage/
    └── test_save/
```

### Module Structure

| Module | Responsibility | Dependencies |
|--------|---------------|--------------|
| `autoload/` | Global singletons | None |
| `combat/` | Combat system logic | data/, autoload/ |
| `run/` | Run progression | data/, autoload/ |
| `data/` | Data classes | None |
| `ui/` | UI components | autoload/ |

### Testing Strategy

**Framework:** GUT (Godot Unit Test)

**Coverage Approach:** Critical path only - Focus on high-risk, high-value systems

| Test Type | Scope | Target |
|-----------|-------|--------|
| Unit Tests | Damage calc, pincer/chain detection, save/load, gacha probability | 90%+ on critical systems |
| Scene Tests | CombatScene, RunMapScene, GachaScene initialization | Key integration points |
| Manual Tests | Full game flow, UI responsiveness | Pre-release checklist |
| Performance Tests | 60 FPS during combat | Godot Profiler |

**Test Priorities (Critical Path):**
1. **Damage Calculation** (FR-003) - Complex formulas, easy to break
2. **Pincer/Chain Detection** (FR-002, FR-004) - Intricate rules, high bug risk
3. **Save/Load Integrity** (NFR-008, NFR-009) - Critical for player trust
4. **Gacha Probability** (FR-020) - Must verify rates match displayed percentages

**Test File Structure:**
```
tests/
├── unit/
│   ├── test_damage_calculator.gd
│   ├── test_pincer_detection.gd
│   ├── test_chain_resolution.gd
│   ├── test_save_manager.gd
│   └── test_gacha_probability.gd
├── scene/
│   ├── test_combat_scene.gd
│   ├── test_run_map_scene.gd
│   └── test_gacha_scene.gd
└── test_config.gd
```

**Scene Test Examples:**
- CombatScene: Verify initializes with enemies, signals fire on victory/defeat
- RunMapScene: Verify generates valid map, nodes are selectable
- GachaScene: Verify pull costs deducted, results within rarity rates

**Rationale for Critical Path Only:**
- Solo developer with 6-month timeline
- UI tests are brittle and low-value
- Add regression tests for bugs encountered post-launch
- Expand coverage iteratively based on bug patterns

### CI/CD Pipeline

```yaml
# .github/workflows/build.yml
name: Build

on:
  push:
    branches: [main]
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run GUT Tests
        # Godot headless test execution

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - name: Build Android APK
      - name: Upload Artifact

  build-ios:
    needs: test
    runs-on: macos-latest
    steps:
      - name: Build iOS
      - name: Upload Artifact
```

---

## Deployment Architecture

### Environments

| Environment | Purpose | Configuration |
|-------------|---------|---------------|
| Development | Local dev, Godot editor | Debug builds, verbose logging |
| Staging | Internal testing | Release build, debug symbols |
| Production | App store submission | Release build, optimized |

### Deployment Strategy

**Mobile App Stores:**
1. Build with Godot export templates
2. Sign with developer certificates
3. Upload to TestFlight (iOS) / Internal Test Track (Android)
4. Beta testing period
5. Submit for review
6. Phased rollout (if issues detected)

### Infrastructure as Code

**Not Applicable:** No server infrastructure.

---

## Requirements Traceability

### Functional Requirements Coverage

| FR ID | FR Name | Component(s) | Notes |
|-------|---------|--------------|-------|
| FR-001 | Grid-Based Movement | CombatScene, InputHandler | 6x8 grid, 4s timer |
| FR-002 | Pincer Attack System | CombatScene, DamageCalculator | Horizontal/vertical/corner |
| FR-003 | Damage Calculation | DamageCalculator | ATK/DEF formulas |
| FR-004 | Chain Attack System | CombatScene, TurnManager | Resolution order |
| FR-005 | Elemental System | UnitData, DamageCalculator | 5 elements |
| FR-006 | Character Skills | SkillData, SkillExecutor | AOE patterns |
| FR-007 | Turn System | TurnManager | Player/enemy phases |
| FR-008 | Node-Based Map | RunMapScene, MapGenerator | 4 node types |
| FR-009 | Procedural Map Generation | MapGenerator | Seeded random |
| FR-010 | Combat Nodes | NodeHandler | Enemy encounters |
| FR-011 | Healing Nodes | NodeHandler | Heal/revive choice |
| FR-012 | Event Nodes | NodeHandler | TBD event types |
| FR-013 | Boss Encounters | NodeHandler, CombatScene | Unique mechanics |
| FR-014 | Run Completion Rewards | RunState, GameManager | Loot distribution |
| FR-015 | Run Failure Handling | RunState | Reduced rewards |
| FR-016 | Character Stats | UnitData, RunUnit | HP/ATK/DEF/MATK/MDEF |
| FR-017 | Run-Based Leveling | RunState, RunUnit | Lvl 1-5 per run |
| FR-018 | Post-Combat Draft | RunMapScene | 3 random, pick 1 |
| FR-019 | Gacha Banners | GachaScene | Diamond cost |
| FR-020 | Pull Rates & Rarity | UnitDatabase | 3/4/5 star |
| FR-021 | Character Collection | PlayerData, OwnedUnit | Charges system |
| FR-022 | Team Building | TeamBuilderScene | 6-unit presets |
| FR-023 | Main Menu | MainMenuScene | Hub navigation |
| FR-024 | Unit Collection Screen | CollectionScene | Browse/filter units |
| FR-025 | Run Selection Screen | MainMenuScene | Preset selection |
| FR-026 | Combat UI | CombatScene | HP bars, timer, icons |
| FR-027 | Gacha Interface | GachaScene | Banner/pull/results |
| FR-028 | Currency Display | GameManager, UI | Gold/diamonds |

### Non-Functional Requirements Coverage

| NFR ID | NFR Name | Solution | Validation |
|--------|----------|----------|------------|
| NFR-001 | 60 FPS | Object pooling, efficient rendering | Profiler benchmark |
| NFR-002 | Load Times | Async loading, progress UI | Stopwatch test |
| NFR-003 | Touch Response | `_input()` processing, visual feedback | Frame counting |
| NFR-004 | OS Support | Godot export templates | Device testing |
| NFR-005 | Hardware | Memory budget, texture atlases | 2GB device test |
| NFR-006 | Touch Interface | 44px minimum targets | UI audit |
| NFR-007 | Readability | 14pt+ fonts, high contrast | Small screen test |
| NFR-008 | Local Save | Resource serialization | Persistence test |
| NFR-009 | Crash Recovery | RunSaveData checkpoints | Kill/resume test |
| NFR-010 | Offline Play | No network calls | Airplane mode test |
| NFR-011 | Save Security | Not encrypted (MVP) | Risk accepted |

---

## Trade-offs & Decision Log

### Decision 1: Godot Resources vs. JSON

**Decision:** Use Godot Resources (.tres) for save data

**Trade-offs:**
- ✓ Native serialization, no parsing overhead
- ✓ Type-safe with custom Resource classes
- ✗ Godot-specific format (less portable)
- ✗ Requires Godot to edit/inspect

**Rationale:** Performance and simplicity outweigh portability for a Godot-only project.

---

### Decision 2: Scene-Based vs. Event Bus Architecture

**Decision:** Scene-based with autoload singletons

**Trade-offs:**
- ✓ Idiomatic Godot, easy to understand
- ✓ Self-contained scenes are testable
- ✗ Some coupling via autoloads
- ✗ Global state in singletons

**Rationale:** Solo developer benefits from simplicity. Event bus pattern can be added later if needed.

---

### Decision 3: GDScript vs. C#

**Decision:** GDScript primary, C# optional for hotspots

**Trade-offs:**
- ✓ Rapid iteration with GDScript
- ✓ C# available if performance issues
- ✗ GDScript less performant
- ✗ Mixed codebase complexity if C# used

**Rationale:** Start simple, optimize only if profiling reveals bottlenecks.

---

### Decision 4: No Backend (MVP)

**Decision:** Fully offline, local-only game

**Trade-offs:**
- ✓ Simpler development, no server costs
- ✓ Works anywhere, no connectivity issues
- ✗ No cloud saves (device loss = data loss)
- ✗ No social features, leaderboards

**Rationale:** MVP scope constraint. Cloud features can be added post-launch without architectural changes.

---

## Open Issues & Risks

### Technical Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Combat performance on low-end devices | Medium | High | Early profiling, optimize critical paths |
| Godot mobile export issues | Low | Medium | Test on real devices early |
| Save data corruption | Low | High | Atomic writes, backup saves |
| Gacha probability verification | Medium | Medium | Automated testing, logging |

### Open Issues

1. **Event Node Content:** Specific event types and outcomes undefined (FR-012)
2. **Boss Mechanics:** Unique behaviors undefined (FR-013)
3. **Enemy AI:** Movement/targeting logic undefined (FR-007)
4. **Diamond Acquisition:** How players earn premium currency undefined (FR-019)

---

## Assumptions & Constraints

### Assumptions

- Godot 4.x remains stable and supported throughout development
- Target devices have at least 2GB RAM
- Players accept offline-only, no cloud saves (MVP)
- 6 units sufficient for launch roster
- No regulatory issues with gacha mechanics in target markets

### Constraints

- Solo developer (all roles)
- Self-funded (no budget for servers/services)
- No art/audio skills (AI and asset packs required)
- Mobile-only (no PC/console)
- Portrait orientation only

---

## Future Considerations

### Post-MVP Features

| Feature | Architectural Impact |
|---------|---------------------|
| Cloud Saves | Add backend integration, authentication |
| Meta Progression | New permanent unlock system |
| Story/Events | New scene types, dialogue system |
| PvP/Multiplayer | Network layer, matchmaking |
| Artifacts | New data model, run modifiers |

### Scalability Path

1. **Phase 1 (MVP):** Local-only, as designed
2. **Phase 2:** Add optional cloud saves (Firebase/PlayFab)
3. **Phase 3:** Add online features (leaderboards, events)
4. **Phase 4:** Add multiplayer if demand exists

---

## Approval & Sign-off

**Review Status:**
- [ ] Technical Lead (rboniface)
- [ ] Product Owner (rboniface)

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-03-09 | rboniface | Initial architecture |

---

## Next Steps

### Phase 4: Sprint Planning & Implementation

Run `/sprint-planning` to:
- Break epics into detailed user stories
- Estimate story complexity
- Plan sprint iterations
- Begin implementation following this architectural blueprint

**Key Implementation Principles:**
1. Follow component boundaries defined in this document
2. Implement NFR solutions as specified
3. Use technology stack as defined
4. Follow scene organization patterns
5. Adhere to performance guidelines

---

**This document was created using BMAD Method v6 - Phase 3 (Solutioning)**

*To continue: Run `/workflow-status` to see your progress and next recommended workflow.*
