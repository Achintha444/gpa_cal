---
name: paper-layout-patterns
description: Proven flex layout patterns for mobile screens in Paper — centering, sticky bottom CTAs, form screens
metadata:
  type: feedback
---

# Paper Layout Patterns for Mobile Screens

## Centering content vertically in a fixed-height artboard

The artboard must be `display: flex; flexDirection: column`. The content wrapper must be `flex: 1` to fill remaining height. `justifyContent: center` then centers within that space.

**Why:** Paper's flexbox model mirrors CSS — children don't stretch unless `flex: 1` is set. Without it, the content sits at the top even when justify-content is set.

```html
<!-- Artboard: display:flex; flexDirection:column; height:844px -->
<div style="display:flex; flex-direction:column; flex:1; align-items:center; justify-content:center;">
  <!-- centered content here -->
</div>
```

## Sticky bottom CTA pattern

Use `flex: 1; display:flex; flex-direction:column; justify-content:flex-end` on the container holding the button. This pushes the button to the bottom of remaining space.

**Why:** This is the correct pattern for screens where form content sits near the top and the primary CTA should be at the bottom of the viewport.

```html
<!-- After progress bar + form sections -->
<div style="flex:1; display:flex; flex-direction:column; justify-content:flex-end; padding:0 24px 48px 24px;">
  <button style="width:100%; height:48px; background:#2563EB; border-radius:12px; ...">Label</button>
</div>
```

## fit-content artboard height

Use `height: "fit-content"` when content may exceed 844px (e.g., forms with multiple course cards). This prevents clipping. Use it proactively for screens D-09 (First Semester) and Add Semester.

## Progress bar (full-width, no padding)

Place the progress bar as a direct child of the artboard, BEFORE any padded containers. Do NOT wrap it in a padded container.

```html
<div style="width:100%; height:4px; background-color:#E5E7EB;">
  <div style="width:33%; height:4px; background-color:#2563EB;"></div>
</div>
```

## Status bar color

- Light background screens: use `color: black` on time text and `fill: black` on SVG
- Dark/cobalt backgrounds: use `color: white` and `fill: white`

## Floating pill bottom nav (Academic Bold style)

The D-15–D-22 redesign validated this pattern for the floating bottom nav:
```html
<div style="position: absolute; bottom: 20px; left: 20px; right: 20px; background: #FFFFFF; border-radius: 999px; height: 64px; display: flex; align-items: center; justify-content: space-around; box-shadow: 0 8px 32px rgba(0,0,0,0.12); padding: 0 16px;">
```
- For fit-content artboards (no absolute), use `margin: 20px 0 0; position: relative;` wrapper with inner `margin: 0 20px;` on the pill.
- Active item: icon + label in `#2563EB`, font-weight 700, 5px dot indicator at bottom.
- Inactive items: icon + label in `#9CA3AF`, font-weight 500.

## Bottom Sheet pattern (D-17 Delete Confirmation)

Bottom sheet MUST use absolute positioning to overlay the dimmed background:
```html
<!-- Overlay covers full artboard -->
<div style="position: absolute; top:0; left:0; right:0; bottom:0; background: rgba(17,24,39,0.4);"></div>
<!-- Sheet sticks to bottom -->
<div style="position: absolute; bottom:0; left:0; right:0; background:#FFFFFF; border-radius: 24px 24px 0 0; padding:12px 24px 34px;">
```
Key elements: 40×4px drag handle, 56px icon circle (#FEF2F2 bg), title ExtraBold 800 22px, body 14px Regular with explicit `width: 294px` to prevent overflow.

## Academic Bold card style (D-15+ redesign)

Cards use colored shadows instead of borders:
- `box-shadow: 0 4px 20px rgba(37,99,235,0.08)` — cobalt-tinted for elevated cards
- `border-radius: 20px` for hero cards, `16px` for list rows
- Section headers: `font-size: 11px; font-weight: 800; color: #9CA3AF; letter-spacing: 0.12em; text-transform: uppercase`
- GPA numbers: `font-size: 48px; font-weight: 800; color: #F59E0B`
- Grade pills color-coding: A range = `#EFF6FF` bg + `#2563EB` text; B range = `#FFF7ED` bg + `#EA580C` text

## SVG line chart in Paper

Use a single SVG element with `position: absolute; top:0; left:0; width:100%; height:100%` inside a container div with explicit height. Use `defs > linearGradient` for gradient fills under the line. Data points: 8px circles with `stroke="white" stroke-width="2"` for outlined look. X-axis labels as SVG `<text>` elements.
