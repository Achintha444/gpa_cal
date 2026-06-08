---
name: project-context
description: GPA Cal Paper file ID, existing artboard IDs, design system doc locations
metadata:
  type: project
---

# GPA Cal — Project Context

**Paper File ID:** `01KTFCV548W019M8TT61R1299A`

**Why:** This is the authoritative design file. Open with `open_file({ fileId: "01KTFCV548W019M8TT61R1299A" })` at the start of every session.

**How to apply:** Always open this file first, then call `get_basic_info()` to see current artboard list.

## Design System Artboards on V4 — Editorial (DO NOT modify)

| Artboard | ID | Contents |
|----------|-----|----------|
| 01 — Color Palette | `405-0` | Surfaces (4), Brand+Text (5), Semantic (4), Derived Tints (4) |
| 02 — Typography Scale | `42I-0` | Headings — Inter Tight (5), Body & Labels — Inter (5), Hierarchy demo |
| 03 — Spacing & Radii | `440-0` | 9 spacing tokens, 5 border radii |
| 04 — Component Library | `460-0` | Buttons (5+full), Inputs (3), Grade chips, Semester cards (4), Stepper, FAB, Segmented, Sheet, Nav, Feedback (3) |

## Screen Artboards — Need Redesign for V4

All V3 screen artboards (D-06 through D-22) exist on the V3 page but need to be redesigned using V4 tokens on the V4 — Editorial page.

### Page 1 (legacy — outdated)

| Screen | ID |
|--------|----|
| D-06 Splash Screen | `AG-0` |
| D-07 Onboarding — Welcome | `B1-0` |
| D-08 Onboarding — Profile | `HB-0` |
| D-09 Onboarding — First Semester | `L3-0` |

### Page: V3 — Light Premium (ID: 2-0) — previous design, superseded by V4

| Screen | ID |
|--------|----|
| D-06 through D-14 | See V3 page |
| D-15 through D-22 | See Page 1 |

### Page: V4 — Editorial (ID: 3-0) — active design page

| Screen | Paper ID | Notes |
|--------|----------|-------|
| D-06 — Splash | `4I9-0` | 390×844px fixed, centered brand moment |
| D-07 — Onboarding: Welcome | `4BL-0` | 390×844px, fit to device height |
| D-08 — Onboarding: Profile Setup | `4BM-0` | 390×844px, fit to device height |
| D-09 — Onboarding: First Semester | `4BN-0` | fit-content (scrollable content) |
| D-10 — Dashboard (With Data) | `4IA-0` | fit-content, 3 semester cards |
| D-14 — Dashboard (Empty State) | `4IB-0` | fit-content, empty state CTA |
| D-11 — Add Semester | `4IN-0` | fit-content, 2 course cards, grade chips, credit stepper |
| D-12 — Edit Semester | `4SW-0` | fit-content, identical to D-11 + red delete icon in app bar right |
| D-15 — Semester Detail | `536-0` | fit-content, read-only course list with grade badges + GPA points |
| D-16 — Analytics Tab | `4IO-0` | fit-content, SVG line chart + summary cards + What-If CTA + semester list |
| D-17 — What-If Calculator | `4IP-0` | fit-content, current state card + focused input + steppers + result card |
| D-18 — Analytics Empty State | `4IQ-0` | 844px fixed, vertically centered empty state with bottom nav |
| D-19 — Settings | `4KG-0` | 844px fixed, profile + preferences + data + about sections + bottom nav (Settings active) |
| D-20 — Export / Share | `4KH-0` | 844px fixed, PDF preview card + Save to Files/Share button pair |
| D-21 — Set Semester Name (Bottom Sheet) | `4KU-0` | 844px fixed, scrim overlay + bottom sheet, input empty/disabled Create state |
| D-22 — Delete Confirmation Dialog | `4KV-0` | 844px fixed, scrim overlay + centered 320px dialog, destructive Delete button |

## Key Doc Paths

- Design system tokens: `docs/02-design-system.md`
- Screen plan specs: `docs/04-screen-plan.md`
- UX research: `docs/03-ux-research-report.md`
