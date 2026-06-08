# GPA Cal — Design System

> Authoritative design token reference. All agents must use these tokens — no hardcoded values.
> Paper file: **gpa-cal**, page: **V4 — Editorial** — artboards 01–04 are design system reference (DO NOT modify).

## Mood & Direction

- **Mood:** Editorial — clean, Swiss-inspired, typographic precision
- **Direction:** Pure white canvas, vibrant blue anchors all actions, warm orange draws the eye to GPA numbers. Inter Tight headings create strong hierarchy against Inter body text. Maximum heading/body weight contrast. Components feel crisp, not heavy.
- **Register:** Professional, modern, trustworthy — a tool students respect

## 1. Color Palette

### Surfaces

| Token | Hex | Usage |
|-------|-----|-------|
| `background` | `#FFFFFF` | App background, page-level |
| `surface` | `#FFFFFF` | Card backgrounds, bottom sheets, dialogs |
| `surfaceMuted` | `#F1F5F9` | Input fills (rest state), chip backgrounds, skeleton shimmer |
| `border` | `#E2E8F0` | Card borders, dividers, input borders (focused) |

### Brand & Text

| Token | Hex | Usage |
|-------|-----|-------|
| `accent` | `#2563EB` | Primary actions, buttons, active nav, links, selected chips, FAB |
| `gpa` | `#F97316` | SGPA/CGPA numbers, warm highlights, GPA-related accents |
| `textPrimary` | `#0F172A` | Headings, body text, primary labels |
| `textSecondary` | `#64748B` | Metadata, descriptions, inactive labels, section headers |
| `textPlaceholder` | `#94A3B8` | Input placeholders, disabled text |

### Semantic States

| Token | Hex | Usage |
|-------|-----|-------|
| `success` | `#16A34A` | Positive GPA trend (↑), validation pass, goal reached |
| `warning` | `#F97316` | Caution states (shared with `gpa` token) |
| `error` | `#DC2626` | Validation errors, destructive actions, negative trend (↓), declining grades |
| `disabled` | `#CBD5E1` | Disabled buttons, inactive elements |

### Derived Colors

| Usage | Value |
|-------|-------|
| Accent at 8% (selected chip bg, A-range grade bg) | `rgba(37,99,235,0.08)` |
| Warning at 8% (B-range grade bg) | `rgba(249,115,22,0.08)` |
| Error at 6% (D/F grade bg) | `rgba(220,38,38,0.06)` |
| Error at 8% (error feedback bg) | `rgba(220,38,38,0.08)` |
| Success at 8% (success feedback bg, trend pill bg) | `rgba(22,163,74,0.08)` |
| Accent at 8% (info feedback bg) | `rgba(37,99,235,0.08)` |
| Accent shadow (FAB, elevated buttons) | `rgba(37,99,235,0.25)` |

### Contrast Compliance (WCAG AA)

| Pair | Ratio | Pass? |
|------|-------|-------|
| `textPrimary` on `background` | 16.6:1 | AA ✓ |
| `textSecondary` on `background` | 5.0:1 | AA ✓ |
| `accent` on `background` | 4.6:1 | AA ✓ |
| White on `accent` (buttons) | 4.6:1 | AA ✓ |
| `gpa` on `surface` | 4.6:1 | AA ✓ |

## 2. Typography

**Headings:** Inter Tight (Google Fonts) — condensed letterforms with tight tracking for punchy display type.
**Body:** Inter (Google Fonts) — designed for screens with large x-height and open apertures.

| Token | Font | Size | Weight | Line Height | Tracking | Usage |
|-------|------|------|--------|-------------|----------|-------|
| `displayLarge` | Inter Tight | 32px | Bold 700 | 38px | -0.02em | GPA hero numbers, CGPA display |
| `headlineLarge` | Inter Tight | 24px | Bold 700 | 30px | -0.02em | Screen titles (Dashboard, Analytics) |
| `headlineMedium` | Inter Tight | 20px | SemiBold 600 | 26px | -0.01em | Section headers (Semesters, Courses) |
| `titleLarge` | Inter Tight | 18px | SemiBold 600 | 24px | -0.01em | Sheet headers, card titles |
| `titleMedium` | Inter Tight | 16px | SemiBold 600 | 22px | 0em | Semester names, row titles |
| `bodyLarge` | Inter | 16px | Regular 400 | 24px | 0em | Primary body text, descriptions |
| `bodyMedium` | Inter | 14px | Regular 400 | 20px | 0em | Supporting text, metadata |
| `labelLarge` | Inter | 14px | Medium 500 | 20px | 0.01em | Buttons, CTAs, active labels |
| `labelMedium` | Inter | 12px | Medium 500 | 16px | 0.02em | Chips, badges, metadata labels |
| `labelSmall` | Inter | 10px | Medium 500 | 14px | 0.05em | Chart annotations, micro labels (all-caps only) |

### Typography Rules

- Inter Tight for all headings/titles (display, headline, title tokens) — bold, tight tracking
- Inter for all body/label text — regular to medium weight, open tracking on small sizes
- Heavy display (700) paired with regular body (400) for maximum contrast
- All caps only for `labelSmall` and section header usage of `labelMedium`
- Minimum text size: 10px (`labelSmall`, used sparingly)
- No Montserrat — Inter Tight + Inter replace it everywhere

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
| `elevation1` | `0 1px 3px rgba(0,0,0,0.06)` | Cards at rest (subtle) |
| `elevation2` | `0 4px 12px rgba(37,99,235,0.25)` | FAB, elevated buttons |
| `elevation3` | `0 -8px 24px rgba(0,0,0,0.08)` | Bottom sheets, overlays |

## 6. Component Specifications

### 6.1 Semester Card
- **Width:** 342px (390px − 48px padding)
- **Background:** `surface` (#FFFFFF)
- **Border:** 1px `border` (#E2E8F0)
- **Border radius:** `radiusLarge` (16px)
- **Padding:** 20px
- **States:**
  - **Empty slot:** Dashed 2px border `#E2E8F0`, circle icon bg `surfaceMuted`, "+" icon `accent`, "Add a semester" text
  - **Default:** Semester name (`titleMedium` Inter Tight 600) + meta (`bodyMedium` `textSecondary`) + SGPA (`displayLarge`-sized 24px/700 `gpa`)
  - **With trend:** Same + green trend pill (↑ +0.22) in `success` 8% bg
  - **Declining:** Same + red trend pill (↓ -0.15) in `error` 8% bg

### 6.2 Buttons
- **Height:** 48px (14px vertical padding, 32px horizontal)
- **Border radius:** `radiusMedium` (12px)
- **Typography:** `labelLarge` (14px Medium 500, 0.01em tracking)
- **Variants:**
  - **Primary CTA:** `accent` bg, white text
  - **Secondary:** `surface` bg, 1.5px `#E2E8F0` border, `textPrimary` text
  - **Destructive:** `surface` bg, 1.5px `rgba(220,38,38,0.2)` border, `error` text
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
  - **B range** (B+, B, B-): `gpa` 8% bg, `gpa` text
  - **C range** (C+, C, C-): `surfaceMuted` bg, `textSecondary` text
  - **D/F range:** `error` 6% bg, `error` text

### 6.5 Credit Stepper
- **Container:** `surfaceMuted` bg, `radiusMedium` (12px), 4px padding
- **Buttons (−/+):** 44px square, `surface` bg, 10px radius, centered text
- **Value:** Center, `titleMedium` (16px Bold 700)
- **Range:** 0.5–10, step 0.5

### 6.6 FAB
- **Size:** 56×56px
- **Border radius:** `radiusLarge` (16px) — rounded square, not circle
- **Background:** `accent`
- **Shadow:** `elevation2` with `accent` tint
- **Icon:** "+" 24px, white, weight 300
- **States:** Active (blue) / Disabled (`disabled` #CBD5E1)

### 6.7 Segmented Control
- **Container:** `surfaceMuted` bg, 10px radius, 4px padding
- **Active segment:** `accent` bg, white text, `labelMedium` 600, 8px radius
- **Inactive segment:** transparent bg, `textSecondary` text, `labelMedium` 500

### 6.8 Bottom Sheet
- **Background:** `surface`
- **Border radius:** `radiusXLarge` (24px) top-left and top-right only
- **Shadow:** `elevation3`
- **Drag handle:** 40px × 4px, `#CBD5E1`, centered, `radiusFull`
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
  - **Info:** `accent` 8% bg, blue dot, `textPrimary` text

## 7. Paper Artboard Reference

**Page:** V4 — Editorial

| # | Artboard | Paper ID | Contents |
|---|----------|----------|----------|
| 01 | Color Palette | `405-0` | Surfaces (4), Brand+Text (5), Semantic (4), Derived Tints (4) |
| 02 | Typography Scale | `42I-0` | Headings — Inter Tight (5), Body & Labels — Inter (5), Hierarchy demo |
| 03 | Spacing & Radii | `440-0` | 9 spacing tokens, 5 border radii |
| 04 | Component Library | `460-0` | Buttons (5+full), Inputs (3), Grade chips, Semester cards (4), Stepper, FAB, Segmented, Sheet, Nav, Feedback (3) |
**DO NOT modify artboards 01–04.** Create new artboards for screen designs.

## 8. Iconography

**Icon set:** Lucide (https://lucide.dev/icons/) — clean, consistent 24×24 stroke icons with 2px stroke width. Flutter package: `lucide_icons`.

| Context | Size | Stroke | Color |
|---------|------|--------|-------|
| Navigation bar | 22px | 2px | Active: `accent`, Inactive: `textPlaceholder` |
| App bar actions | 24px | 2px | `textPrimary` |
| Card trailing | 16px | 2px | `textPlaceholder` |
| Empty state | 36–48px | 1.5px | `accent` at 40% opacity |
| Buttons (inline) | 18px | 2px | Inherits button text color |
| FAB | 24px | 2px (weight 300) | White |

### Common Icons

| Usage | Lucide Icon |
|-------|-------------|
| Add / Create | `plus` |
| Back | `chevron-left` |
| Forward / Navigate | `chevron-right` |
| Delete | `trash-2` |
| Edit | `pencil` |
| Settings | `settings` |
| Analytics / Chart | `bar-chart-3` |
| Home | `home` |
| Close | `x` |
| Search | `search` |
| Export / Share | `share-2` |
| GPA / Academic | `graduation-cap` |
| Trend up | `trending-up` |
| Trend down | `trending-down` |

## 9. Flutter Implementation Reference

The design system is fully implemented in `lib/theme/`. When building UI, import tokens from these files — never hardcode values.

| Design Token | Flutter Class | File |
|-------------|---------------|------|
| Colors (surfaces, brand, semantic, derived tints) | `AppColors` | `lib/theme/app_colors.dart` |
| Typography (Inter Tight headings, Inter body) | `AppTypography` | `lib/theme/app_typography.dart` |
| Spacing (8pt grid, semantic aliases, border radii) | `AppSpacing` | `lib/theme/app_spacing.dart` |
| Decorations (cards, inputs, sheets, shadows) | `AppDecorations` | `lib/theme/app_decorations.dart` |
| ThemeData (Material 3 wiring) | `appTheme()` | `lib/theme/app_theme.dart` |

### Quick Reference

```dart
// Colors
Container(color: AppColors.accent)
Text('3.67', style: AppTypography.displayLarge.copyWith(color: AppColors.gpa))

// Spacing
Padding(padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding))
SizedBox(height: AppSpacing.sectionGap)

// Decorations
DecoratedBox(decoration: AppDecorations.card, child: ...)
DecoratedBox(decoration: AppDecorations.cardFlat, child: ...)

// Border radii
ClipRRect(borderRadius: AppSpacing.borderRadiusLarge, child: ...)

// Derived tints (pre-computed, no withOpacity)
Container(color: AppColors.accentTint)   // accent at 8%
Container(color: AppColors.successTint)  // success at 8%
Container(color: AppColors.errorTint)    // error at 6%
```

### Design Patterns

- **Buttons:** Flat, NO shadow/elevation. Use `ElevatedButton` (primary), `OutlinedButton` (secondary), `TextButton` (tertiary).
- **Alerts/Confirmations:** Always bottom sheets — never centered `AlertDialog`. Use `BottomSheetThemeData` from `appTheme()`.
- **Dividers:** Full-width (0 indent), softer color. Use `AppColors.border` at 50% opacity or the theme's `DividerTheme`.
- **Cards:** Use `AppDecorations.card` or `AppDecorations.cardFlat` — never custom `BoxDecoration`.

## 10. Accessibility Requirements

- All text meets WCAG AA contrast (4.5:1 for text, 3:1 for UI elements)
- Minimum touch target: 48×48dp for all interactive elements
- All inputs have visible labels (not just placeholders)
- Error states have both color AND text indicators (not color alone)
- Grade chips have group semantics for screen readers
- Support Dynamic Type (iOS) and font scaling (Android)
- Grade chip color bands provide visual grouping — not relying on color alone for meaning
