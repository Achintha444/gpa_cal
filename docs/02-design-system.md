# GPA Cal — Design System

> Authoritative design token reference. All agents must use these tokens — no hardcoded values.
> Paper file: **gpa-cal**, page: **V3 — Light Premium** — artboards 01–04 are design system reference (DO NOT modify).

## Mood & Direction

- **Mood:** Light Premium — clean, sophisticated, like Notion meets Todoist meets Apple
- **Direction:** Information lives directly on surfaces. Deep navy accent anchors the brand. Warm orange draws the eye to GPA numbers. No decorative noise — every element earns its place.
- **Register:** Professional, trustworthy, modern — a tool students respect

## 1. Color Palette

### Surfaces

| Token | Hex | Usage |
|-------|-----|-------|
| `background` | `#FAFAFA` | App background, page-level |
| `surface` | `#FFFFFF` | Card backgrounds, bottom sheets, dialogs |
| `surfaceMuted` | `#F3F4F6` | Input fills (rest state), chip backgrounds, skeleton shimmer |
| `border` | `rgba(0,0,0,0.06)` | Card borders, dividers, input borders (focused) |

### Brand & Text

| Token | Hex | Usage |
|-------|-----|-------|
| `accent` | `#1E3A5F` | Primary actions, buttons, active nav, links, selected chips, FAB |
| `gpa` | `#E67E22` | SGPA/CGPA numbers, warm highlights, GPA-related accents |
| `textPrimary` | `#1A1A2E` | Headings, body text, primary labels |
| `textMuted` | `#8E8E9A` | Metadata, descriptions, inactive labels, section headers |
| `textPlaceholder` | `#C4C4CC` | Input placeholders, disabled text |

### Semantic States

| Token | Hex | Usage |
|-------|-----|-------|
| `success` | `#27AE60` | Positive GPA trend (↑), validation pass, goal reached |
| `warning` | `#E67E22` | Caution states (shared with `gpa` token) |
| `error` | `#E74C3C` | Validation errors, destructive actions, negative trend (↓), declining grades |
| `disabled` | `#D1D5DB` | Disabled buttons, inactive elements |

### Derived Colors

| Usage | Value |
|-------|-------|
| Accent at 8% (selected chip bg, A-range grade bg) | `rgba(30,58,95,0.08)` |
| Warning at 8% (B-range grade bg) | `rgba(230,126,34,0.08)` |
| Error at 6% (D/F grade bg) | `rgba(231,76,60,0.06)` |
| Error at 8% (error feedback bg) | `rgba(231,76,60,0.08)` |
| Success at 8% (success feedback bg, trend pill bg) | `rgba(39,174,96,0.08)` |
| Accent at 8% (info feedback bg) | `rgba(30,58,95,0.08)` |
| Accent shadow (FAB, elevated buttons) | `rgba(30,58,95,0.25)` |

### Contrast Compliance (WCAG AA)

| Pair | Ratio | Pass? |
|------|-------|-------|
| `textPrimary` on `background` | 14.8:1 | AA ✓ |
| `textMuted` on `background` | 4.6:1 | AA ✓ |
| `accent` on `background` | 8.2:1 | AA ✓ |
| White on `accent` (buttons) | 8.2:1 | AA ✓ |
| `gpa` on `surface` | 4.6:1 | AA ✓ |

## 2. Typography

**Font:** Inter (Google Fonts) — designed for screens with large x-height and open apertures. Optical sizing adapts weight to display size automatically.

| Token | Size | Weight | Line Height | Tracking | Usage |
|-------|------|--------|-------------|----------|-------|
| `displayLarge` | 32px | Bold 700 | 38px | -0.02em | GPA hero numbers, CGPA display |
| `headlineLarge` | 24px | SemiBold 600 | 30px | -0.01em | Screen titles (Dashboard, Analytics) |
| `headlineMedium` | 20px | SemiBold 600 | 26px | -0.01em | Section headers (Semesters, Courses) |
| `titleLarge` | 18px | Medium 500 | 24px | 0em | Sheet headers, card titles |
| `titleMedium` | 16px | Medium 500 | 22px | 0em | Semester names, row titles |
| `bodyLarge` | 16px | Regular 400 | 24px | 0em | Primary body text, descriptions |
| `bodyMedium` | 14px | Regular 400 | 20px | 0em | Supporting text, metadata |
| `labelLarge` | 14px | Medium 500 | 20px | 0.01em | Buttons, CTAs, active labels |
| `labelMedium` | 12px | Medium 500 | 16px | 0.02em | Chips, badges, metadata labels |
| `labelSmall` | 10px | Medium 500 | 14px | 0.05em | Chart annotations, micro labels (all-caps only) |

### Typography Rules

- Heavy display (700) paired with regular body (400) for maximum contrast
- Tight tracking on display type (-0.02em), open on small labels (0.05em)
- All caps only for `labelSmall` and section header usage of `labelMedium`
- Minimum text size: 10px (`labelSmall`, used sparingly)
- No Montserrat — Inter replaces it everywhere

## 3. Spacing

**Base grid:** 8pt. All values are multiples of 4px.

| Token | Value | Usage |
|-------|-------|-------|
| `space4` | 4px | Micro gaps between related elements |
| `space8` | 8px | Icon-to-text, inline element spacing |
| `space12` | 12px | Card gaps, list item spacing |
| `space16` | 16px | Card internal padding |
| `space20` | 20px | Input padding, chip groups |
| `space24` | 24px | Screen padding (primary) |
| `space32` | 32px | Section gap |
| `space40` | 40px | Large section separation |
| `space48` | 48px | FAB bottom margin, hero spacing |
| `space64` | 64px | Bottom safe area, generous hero |

### Semantic Aliases

| Alias | Token | Usage |
|-------|-------|-------|
| `screenPadding` | `space24` | Horizontal safe zone on all screens |
| `cardPadding` | `space16` | Internal padding for all card components |
| `cardGap` | `space12` | Vertical gap between semester cards |
| `sectionGap` | `space32` | Between major sections on home screen |

## 4. Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| `radiusSmall` | 8px | Chips, tags, grade badges |
| `radiusMedium` | 12px | Buttons, inputs, feedback toasts |
| `radiusLarge` | 16px | Cards, semester cards, FAB |
| `radiusXLarge` | 24px | Bottom sheets (top corners only) |
| `radiusFull` | 50% | Avatars, circular indicators, dot badges |

## 5. Elevation / Shadow

| Level | Shadow | Usage |
|-------|--------|-------|
| `elevation0` | none | Flat elements, inline content |
| `elevation1` | `0 1px 2px rgba(0,0,0,0.04)` | Cards at rest (subtle, barely visible) |
| `elevation2` | `0 4px 12px rgba(30,58,95,0.12)` | FAB, elevated buttons |
| `elevation3` | `0 8px 24px rgba(0,0,0,0.08)` | Bottom sheets, overlays |

## 6. Component Specifications

### 6.1 Semester Card
- **Width:** 342px (390px − 48px padding)
- **Background:** `surface` (#FFFFFF)
- **Border:** 1px `border` (rgba(0,0,0,0.06))
- **Border radius:** `radiusLarge` (16px)
- **Padding:** 20px
- **States:**
  - **Empty slot:** Dashed border, `surfaceMuted` bg, "+" circle + "Add a semester" text
  - **Default:** Semester name (`titleMedium` 600) + meta (`bodyMedium` `textMuted`) + SGPA (`displayLarge`-sized 22px/700 `gpa`)
  - **With trend:** Same + green trend pill (↑ +0.22) in `success` 8% bg
  - **Declining:** Same + red trend pill (↓ -0.15) in `error` 8% bg

### 6.2 Buttons
- **Height:** 48px (14px vertical padding, 32px horizontal)
- **Border radius:** `radiusMedium` (12px)
- **Typography:** `labelLarge` (14px Medium 500, 0.01em tracking)
- **Variants:**
  - **Primary CTA:** `accent` bg, white text
  - **Secondary:** `surface` bg, 1.5px `rgba(0,0,0,0.1)` border, `textPrimary` text
  - **Destructive:** `surface` bg, 1.5px `rgba(231,76,60,0.2)` border, `error` text
  - **Disabled:** `surfaceMuted` bg, `textPlaceholder` text
  - **Text:** No bg/border, `accent` text

### 6.3 Text Input
- **Height:** 48px minimum (14px vertical padding, 16px horizontal)
- **Border radius:** `radiusMedium` (12px)
- **Label:** `labelMedium` (12px Medium 500) above input, 8px gap
- **States:**
  - **Default:** `surfaceMuted` bg, no border, placeholder in `textPlaceholder`
  - **Focused:** `surface` bg, 2px `accent` border, label color changes to `accent`
  - **Error:** `surface` bg, 2px `error` border, label + helper text in `error`

### 6.4 Grade Chips
- **Layout:** Horizontal wrap, `space8` gap, dividers between performance bands
- **Padding:** 8px 16px per chip
- **Border radius:** `radiusSmall` (8px)
- **Typography:** `labelMedium` (13px SemiBold 600)
- **Color bands:**
  - **A range** (A+, A, A-): Selected → `accent` bg, white text. Unselected → `accent` 8% bg, `accent` text
  - **B range** (B+, B, B-): `warning` 8% bg, `gpa` text
  - **C range** (C+, C, C-): `surfaceMuted` bg, `textMuted` text
  - **D/F range:** `error` 6% bg, `error` text

### 6.5 Credit Stepper
- **Container:** `surfaceMuted` bg, `radiusMedium` (12px), no border
- **Buttons (−/+):** 44px square, `surface` bg, centered text
- **Value:** Center, `titleMedium` (16px Bold 700)
- **Range:** 0.5–10, step 0.5

### 6.6 FAB
- **Size:** 56×56px
- **Border radius:** `radiusLarge` (16px) — rounded square, not circle
- **Background:** `accent`
- **Shadow:** `elevation2` with `accent` tint
- **Icon:** "+" 24px, white, weight 300
- **States:** Active (navy) / Disabled (gray `#D1D5DB`)

### 6.7 Segmented Control
- **Container:** `surfaceMuted` bg, 10px radius, 4px padding
- **Active segment:** `accent` bg, white text, `labelMedium` 600, 8px radius
- **Inactive segment:** transparent bg, `textMuted` text, `labelMedium` 500

### 6.8 Bottom Sheet
- **Background:** `surface`
- **Border radius:** `radiusXLarge` (24px) top-left and top-right only
- **Shadow:** `elevation3`
- **Drag handle:** 40px × 4px, `#D1D5DB`, centered, `radiusFull`
- **Padding:** 12px top (to handle), 24px sides, 24px bottom + 34px safe area

### 6.9 Bottom Navigation
- **Background:** `surface`
- **Border top:** 1px `border`
- **Height:** 56px + safe area
- **Items:** 3 tabs — Home, Analytics, Settings
- **Active:** `accent` icon + text, `labelSmall` 600
- **Inactive:** `textPlaceholder` icon + text, `labelSmall` 500
- **Icon size:** 22px, 2px stroke

### 6.10 Feedback Toasts
- **Border radius:** `radiusMedium` (10px)
- **Padding:** 12px 16px
- **Layout:** 8px dot indicator + `labelLarge` message text
- **Variants:**
  - **Success:** `success` 8% bg, green dot, `textPrimary` text
  - **Error:** `error` 8% bg, red dot, `textPrimary` text
  - **Info:** `accent` 8% bg, navy dot, `textPrimary` text

## 7. Paper Artboard Reference

**Page:** V3 — Light Premium

| # | Artboard | Paper ID | Contents |
|---|----------|----------|----------|
| 01 | Color Palette | `2CV-0` | Surfaces (4), Brand+Text (5), Semantic (4) |
| 02 | Typography Scale | `2EP-0` | 10 type levels in tabular format, Inter font, "Why Inter?" |
| 03 | Spacing & Grid | `2H6-0` | 10 spacing tokens, 5 border radius, 4 semantic aliases |
| 04 | Component Library | `2K0-0` | Semester card (4 states), buttons (5), inputs (3), grade chips (color-coded), credit stepper, FAB (2), segmented control, bottom sheet, bottom nav, feedback (3) |

**DO NOT modify artboards 01–04.** Create new artboards for screen designs.

## 8. Accessibility Requirements

- All text meets WCAG AA contrast (4.5:1 for text, 3:1 for UI elements)
- Minimum touch target: 48×48dp for all interactive elements
- All inputs have visible labels (not just placeholders)
- Error states have both color AND text indicators (not color alone)
- Grade chips have group semantics for screen readers
- Support Dynamic Type (iOS) and font scaling (Android)
- Grade chip color bands provide visual grouping — not relying on color alone for meaning
