# Sprint Plan: tac'tile

**Date:** 2026-03-09
**Author:** rboniface
**Version:** 1.0
**Sprint Length:** 1 week
**Team Capacity:** 15-18 story points/sprint (20 hrs/week)
**Timeline:** 6 months (~26 sprints)

---

## Executive Summary

This sprint plan breaks down tac'tile's 5 epics into 39 stories totaling 164 points. With a capacity of 15-18 points per week, the project targets completion in approximately 10-11 sprints (2.5-3 months) for MVP, leaving buffer for polish, testing, and store submission.

**Key Milestones:**
- **Sprint 5:** Combat prototype playable
- **Sprint 8:** Full run loop working
- **Sprint 12:** Feature complete (MVP)

---

## Story Point Scale

| Points | Duration | Complexity |
|--------|----------|------------|
| 1 | 1-2 hours | Trivial fix, config change |
| 2 | 2-4 hours | Simple component, minor feature |
| 3 | 4-6 hours | Standard feature, some logic |
| 5 | 1 day | Complex feature, multiple components |
| 8 | 1-2 days | Full feature flow, integration work |

---

## Epic Breakdown & Story Estimates

### EPIC-001: Combat Core (62 points)

**Goal:** Core tactical combat with grid, pincer, chain, damage, elements, skills, turns

| Story ID | Title | Points | Priority |
|----------|-------|--------|----------|
| STORY-001 | Project Setup & Folder Structure | 3 | Must |
| STORY-002 | Grid System - 6x8 Grid Rendering | 3 | Must |
| STORY-003 | Grid System - Unit Placement | 3 | Must |
| STORY-004 | Grid System - Drag Movement | 5 | Must |
| STORY-005 | Grid System - Swap Mechanic | 3 | Must |
| STORY-006 | Grid System - Movement Timer (4s) | 3 | Must |
| STORY-007 | Pincer Detection - Horizontal/Vertical | 5 | Must |
| STORY-008 | Pincer Detection - Corner Pincers | 3 | Must |
| STORY-009 | Damage Calculator - Physical Formula | 5 | Must |
| STORY-010 | Damage Calculator - Magical Formula | 3 | Must |
| STORY-011 | Damage Calculator - Circle of Carnage | 3 | Must |
| STORY-012 | Damage Calculator - Elemental Bonus | 3 | Must |
| STORY-013 | Chain Detection - Row/Column | 5 | Must |
| STORY-014 | Chain Resolution Order | 5 | Must |
| STORY-015 | Skill System - Pincer Skills | 5 | Must |
| STORY-016 | Skill System - Chain Skills | 3 | Must |
| STORY-017 | Turn Manager - Player Phase | 5 | Must |
| STORY-018 | Turn Manager - Enemy Phase | 5 | Must |
| STORY-019 | Win/Lose Conditions | 2 | Must |

---

### EPIC-003: Progression (25 points)

**Goal:** Run-based leveling and post-combat draft upgrades

| Story ID | Title | Points | Priority |
|----------|-------|--------|----------|
| STORY-020 | Unit Stats - Data Model | 3 | Must |
| STORY-021 | Unit Stats - Level Scaling | 3 | Must |
| STORY-022 | Run Units - Initialization | 3 | Must |
| STORY-023 | Draft System - UI & Selection | 5 | Must |
| STORY-024 | Draft System - Level Up Logic | 3 | Must |
| STORY-025 | Draft System - Skill Improvement | 5 | Must |
| STORY-026 | Run Units - Death Tracking | 3 | Must |

---

### EPIC-002: Run System (38 points)

**Goal:** Node-based roguelite map with procedural generation and encounters

| Story ID | Title | Points | Priority |
|----------|-------|--------|----------|
| STORY-027 | Map Generator - Node Structure | 5 | Must |
| STORY-028 | Map Generator - Procedural Layout | 5 | Must |
| STORY-029 | Map Generator - Node Connections | 3 | Must |
| STORY-030 | Node Types - Combat Node | 3 | Must |
| STORY-031 | Node Types - Healing Node | 3 | Must |
| STORY-032 | Node Types - Event Node (Placeholder) | 2 | Must |
| STORY-033 | Node Types - Boss Node | 3 | Must |
| STORY-034 | Run State - Progress Tracking | 3 | Must |
| STORY-035 | Run State - Save/Resume | 5 | Must |
| STORY-036 | Rewards - Completion | 3 | Must |
| STORY-037 | Rewards - Failure | 2 | Must |

---

### EPIC-005: Core UI (25 points)

**Goal:** Main menu, combat UI, run selection, collection view

| Story ID | Title | Points | Priority |
|----------|-------|--------|----------|
| STORY-038 | Main Menu - Structure | 3 | Must |
| STORY-039 | Main Menu - Navigation | 2 | Must |
| STORY-040 | Combat UI - HP Bars | 3 | Must |
| STORY-041 | Combat UI - Timer Display | 2 | Must |
| STORY-042 | Combat UI - Element Icons | 2 | Must |
| STORY-043 | Combat UI - Skill Indicators | 3 | Must |
| STORY-044 | Run Selection - Team Preview | 3 | Must |
| STORY-045 | Collection Screen - Unit List | 5 | Must |
| STORY-046 | Collection Screen - Unit Details | 2 | Must |

---

### EPIC-004: Gacha & Collection (14 points)

**Goal:** Gacha banners, pulls, team building

| Story ID | Title | Points | Priority |
|----------|-------|--------|----------|
| STORY-047 | Gacha - Banner Display | 3 | Must |
| STORY-048 | Gacha - Pull Logic | 5 | Must |
| STORY-049 | Gacha - Pull Animation | 3 | Must |
| STORY-050 | Team Builder - Preset Management | 3 | Must |

---

## Sprint Allocation

### Sprint 1: Foundation (15 points)
**Goal:** Project setup and basic grid

| Story | Points | Status |
|-------|--------|--------|
| STORY-001: Project Setup & Folder Structure | 3 | Pending |
| STORY-002: Grid System - 6x8 Grid Rendering | 3 | Pending |
| STORY-003: Grid System - Unit Placement | 3 | Pending |
| STORY-004: Grid System - Drag Movement | 5 | Pending |
| Buffer | 1 | - |

---

### Sprint 2: Grid Complete (16 points)
**Goal:** Finish grid mechanics, start pincer

| Story | Points | Status |
|-------|--------|--------|
| STORY-005: Grid System - Swap Mechanic | 3 | Pending |
| STORY-006: Grid System - Movement Timer (4s) | 3 | Pending |
| STORY-007: Pincer Detection - Horizontal/Vertical | 5 | Pending |
| STORY-008: Pincer Detection - Corner Pincers | 3 | Pending |
| STORY-020: Unit Stats - Data Model | 2 | Pending |

---

### Sprint 3: Combat Damage (16 points)
**Goal:** Damage calculation working

| Story | Points | Status |
|-------|--------|--------|
| STORY-009: Damage Calculator - Physical Formula | 5 | Pending |
| STORY-010: Damage Calculator - Magical Formula | 3 | Pending |
| STORY-011: Damage Calculator - Circle of Carnage | 3 | Pending |
| STORY-012: Damage Calculator - Elemental Bonus | 3 | Pending |
| STORY-021: Unit Stats - Level Scaling | 2 | Pending |

---

### Sprint 4: Chain System (18 points)
**Goal:** Chain attacks working

| Story | Points | Status |
|-------|--------|--------|
| STORY-013: Chain Detection - Row/Column | 5 | Pending |
| STORY-014: Chain Resolution Order | 5 | Pending |
| STORY-015: Skill System - Pincer Skills | 5 | Pending |
| STORY-016: Skill System - Chain Skills | 3 | Pending |

---

### Sprint 5: Turn System (17 points)
**Goal:** Complete turn cycle

| Story | Points | Status |
|-------|--------|--------|
| STORY-017: Turn Manager - Player Phase | 5 | Pending |
| STORY-018: Turn Manager - Enemy Phase | 5 | Pending |
| STORY-019: Win/Lose Conditions | 2 | Pending |
| STORY-022: Run Units - Initialization | 3 | Pending |
| STORY-026: Run Units - Death Tracking | 2 | Pending |

---

### Sprint 6: Combat Polish & Draft System (16 points)
**Goal:** Combat feel good, start progression

| Story | Points | Status |
|-------|--------|--------|
| STORY-023: Draft System - UI & Selection | 5 | Pending |
| STORY-024: Draft System - Level Up Logic | 3 | Pending |
| STORY-025: Draft System - Skill Improvement | 5 | Pending |
| Buffer (testing/combat tuning) | 3 | - |

---

### Sprint 7: Run Map Foundation (16 points)
**Goal:** Map generation working

| Story | Points | Status |
|-------|--------|--------|
| STORY-027: Map Generator - Node Structure | 5 | Pending |
| STORY-028: Map Generator - Procedural Layout | 5 | Pending |
| STORY-029: Map Generator - Node Connections | 3 | Pending |
| STORY-034: Run State - Progress Tracking | 3 | Pending |

---

### Sprint 8: Node Types (15 points)
**Goal:** All node types functional

| Story | Points | Status |
|-------|--------|--------|
| STORY-030: Node Types - Combat Node | 3 | Pending |
| STORY-031: Node Types - Healing Node | 3 | Pending |
| STORY-032: Node Types - Event Node (Placeholder) | 2 | Pending |
| STORY-033: Node Types - Boss Node | 3 | Pending |
| STORY-035: Run State - Save/Resume | 3 | Pending |
| Buffer | 1 | - |

---

### Sprint 9: Run Completion (15 points)
**Goal:** Full run loop working

| Story | Points | Status |
|-------|--------|--------|
| STORY-036: Rewards - Completion | 3 | Pending |
| STORY-037: Rewards - Failure | 2 | Pending |
| STORY-038: Main Menu - Structure | 3 | Pending |
| STORY-039: Main Menu - Navigation | 2 | Pending |
| STORY-044: Run Selection - Team Preview | 3 | Pending |
| Buffer | 2 | - |

---

### Sprint 10: Combat UI (15 points)
**Goal:** Combat information clear

| Story | Points | Status |
|-------|--------|--------|
| STORY-040: Combat UI - HP Bars | 3 | Pending |
| STORY-041: Combat UI - Timer Display | 2 | Pending |
| STORY-042: Combat UI - Element Icons | 2 | Pending |
| STORY-043: Combat UI - Skill Indicators | 3 | Pending |
| STORY-045: Collection Screen - Unit List | 5 | Pending |

---

### Sprint 11: Gacha System (14 points)
**Goal:** Gacha functional

| Story | Points | Status |
|-------|--------|--------|
| STORY-047: Gacha - Banner Display | 3 | Pending |
| STORY-048: Gacha - Pull Logic | 5 | Pending |
| STORY-049: Gacha - Pull Animation | 3 | Pending |
| STORY-050: Team Builder - Preset Management | 3 | Pending |

---

### Sprint 12: Polish & Collection (16 points)
**Goal:** Feature complete

| Story | Points | Status |
|-------|--------|--------|
| STORY-046: Collection Screen - Unit Details | 2 | Pending |
| Polish & Bug Fixes | 8 | - |
| Playtesting | 4 | - |
| Buffer | 2 | - |

---

### Sprints 13-16: Polish & Content (Buffer)
**Goal:** Add content, polish, and prepare for launch

- Create 8-12 starter units with unique skills
- Create enemy variants
- Create 2-3 boss enemies
- Balance tuning
- Performance optimization
- Add placeholder events
- Sound effects integration
- Tutorial/onboarding

---

### Sprints 17-20: Testing & Submission (Buffer)
**Goal:** Beta testing and store submission

- Internal testing
- Beta testing (TestFlight/Internal Track)
- Bug fixes from testing
- Store asset preparation (screenshots, descriptions)
- iOS App Store submission
- Google Play submission

---

### Sprints 21-26: Launch Buffer (Contingency)
**Goal:** Post-launch support, unexpected issues

- Address store review feedback
- Fix launch bugs
- Add content if ahead of schedule
- Marketing preparation

---

## Requirements Traceability

| Epic | Stories | Total Points | Sprints |
|------|---------|--------------|---------|
| EPIC-001: Combat Core | 19 | 62 | 1-6 |
| EPIC-003: Progression | 7 | 25 | 2, 5-6 |
| EPIC-002: Run System | 11 | 38 | 7-9 |
| EPIC-005: Core UI | 9 | 25 | 9-10 |
| EPIC-004: Gacha & Collection | 4 | 14 | 11 |
| **Total** | **50** | **164** | **12 sprints** |

---

## Risk Buffer

| Category | Sprints | Purpose |
|----------|---------|---------|
| Polish & Content | 13-16 | Content creation, balance, audio |
| Testing & Submission | 17-20 | Beta testing, store processes |
| Launch Buffer | 21-26 | Unexpected issues, review feedback |
| **Total Buffer** | **14 sprints** | 54% of timeline |

---

## Sprint Velocity Tracking

| Sprint | Planned | Completed | Velocity | Notes |
|--------|---------|----------|----------|-------|
| 1 | 15 | - | - | Foundation |
| 2 | 16 | - | - | Grid complete |
| 3 | 16 | - | - | Damage |
| 4 | 18 | - | - | Chains |
| 5 | 17 | - | - | Turns |
| 6 | 16 | - | - | Draft |
| 7 | 16 | - | - | Map gen |
| 8 | 15 | - | - | Nodes |
| 9 | 15 | - | - | Run loop |
| 10 | 15 | - | - | Combat UI |
| 11 | 14 | - | - | Gacha |
| 12 | 16 | - | - | Polish |

---

## Definition of Done

A story is **Done** when:
- [ ] Code implemented and working
- [ ] Passes manual testing in editor
- [ ] No console errors
- [ ] For critical systems: unit test passing
- [ ] Merged to main branch

---

## Sprint Ceremonies

**Weekly Cadence (1-week sprints):**

| Day | Activity |
|-----|----------|
| Monday | Sprint planning (30 min), start stories |
| Tue-Thu | Development |
| Friday | Sprint review (15 min demo), retrospective (15 min), planning for next sprint |

---

## Success Metrics

| Milestone | Target Date | Success Criteria |
|-----------|-------------|------------------|
| Combat Prototype | Sprint 5 | Can play combat end-to-end |
| Run Loop Working | Sprint 8 | Can complete a full run |
| Feature Complete | Sprint 12 | All MVP features implemented |
| Content Ready | Sprint 16 | 8+ units, 2+ bosses, balanced |
| Beta Ready | Sprint 18 | TestFlight/Play Console builds |
| Launch Ready | Sprint 22 | Store submission |

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-03-09 | rboniface | Initial sprint plan |

---

## Next Steps

**Start Sprint 1:**

Run `/dev-story STORY-001` to begin implementing the project setup.

**Sprint 1 Goal:** Project foundation with working grid rendering and unit placement.

---

**This document was created using BMAD Method v6 - Phase 4 (Implementation)**

*To continue: Run `/sprint-status` to check current sprint progress.*
