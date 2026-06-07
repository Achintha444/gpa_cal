---
name: feedback-paper-workflow
description: Paper MCP workflow patterns that have been validated for GPA Cal mobile screen design
metadata:
  type: feedback
---

Status bar color: Use `background: #2563EB` on the status bar div for screens where the content below has a cobalt app bar or colored top (e.g. dashboard). Use `background: #FFFFFF` with dark `color: #1A1F36` and `fill: #1A1F36` SVG for screens with white app bars (e.g. Add Semester).

For bottom-anchored elements (FAB, Bottom Nav, Bottom Sheet) on fixed-height artboards: use `position: absolute` with `bottom` values. FAB: `bottom: 90px, right: 24px`. Bottom Nav: `bottom: 0, height: 80px`. Bottom Sheet: `bottom: 0`.

Semester cards must use `margin-top: 8px` for 8px gap between cards when inside a flex column container (not using `gap` on the parent, since the parent also contains the section header with different spacing).

For skeleton/shimmer states, use `background: #F5F7FA` on card containers and `background: #E5E7EB` on inner placeholder rectangles with `border-radius: 6px`. Using `position: absolute` with specific coordinates gives the most reliable skeleton layout inside fixed-height containers.

The `fit-content` artboard height works correctly for the D-14 course entry screen. Set `"height": "fit-content"` in `create_artboard` styles directly — no need to update after creation.

## Academic Bold Redesign Patterns (validated June 2026)

**CGPA Hero Card:** Use `linear-gradient(135deg, #2563EB 0%, #1E40AF 100%)` with `border-radius: 24px`, `padding: 28px`, `box-shadow: 0 8px 32px rgba(37,99,235,0.28)`. Add two decorative absolute-positioned circles with `rgba(255,255,255,0.06)` and `rgba(255,255,255,0.04)` backgrounds for depth without glassmorphism.

**GPA number hero:** `56px / 800 weight / #FBBF24` — this scale creates the premium fintech moment. Baseline-align with "out of 4.2" in `16px / 400 / rgba(255,255,255,0.5)`.

**Floating bottom nav:** White pill with `border-radius: 999px`, `box-shadow: 0 4px 20px rgba(0,0,0,0.08)`, `padding: 8px 32px`, `margin: 0 20px 24px`. Active tab gets cobalt icon + 6px cobalt indicator dot below label.

**Semester cards:** `border-radius: 20px`, `box-shadow: 0 4px 20px rgba(37,99,235,0.08)` — no border. 8px colored dot (cobalt or green) instead of accent bar for improved/same status.

**Grade chips color-coding:** A-range: `#EFF6FF bg / #2563EB text`. B-range: `#FFF7ED bg / #EA580C text`. C-range: `#F5F7FA bg / #6B7280 text`. D/F: `#FEF2F2 bg / #EF4444 text`. Selected: solid colored bg with white text + shadow.

**Credit stepper:** Pill-shaped container `#F5F7FA` with inner white circles at 36×36px + shadow for the +/- buttons. Value centered at `16px / 700`.

**Bottom sheet overlay:** Use `rgba(17,24,39,0.5)` for overlay. Sheet has `border-radius: 24px 24px 0 0`. Show dashboard skeleton content behind overlay at `opacity: 0.35` for context depth.

**Skeleton shimmer:** Use slight tone variation across 3 card skeletons (`#E8EAF0` → `#ECEEF4` → `#F0F2F7`) to suggest staggered loading. Add white shimmer overlay at 25% opacity for the mid-shimmer freeze-frame look.

**Why:** Validated across D-10 through D-14 "Academic Bold" redesign session — produced premium fintech aesthetic approved by brief.

**How to apply:** Apply these defaults for any new GPA Cal mobile screen designs in the Academic Bold direction.
