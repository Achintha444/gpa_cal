---
name: feedback_no-withopacity
description: Never use withOpacity() — pre-compute alpha hex values in Color() constructor instead
metadata:
  type: feedback
---

Never use `.withOpacity()` on `Color` objects. The Flutter analyzer flags it as deprecated.

**Why:** `withOpacity()` is deprecated in newer Flutter/Dart. Pre-computed alpha in `Color(0xAARRGGBB)` is the correct approach and produces `const` values.

**How to apply:** When you need a semi-transparent color, calculate the hex alpha channel manually:
- 6% opacity → `0x0F` (15/255)
- 8% opacity → `0x14` (20/255)
- 25% opacity → `0x40` (64/255)
- 50% opacity → `0x80` (128/255)

Example: `Color(0x142563EB)` is accent at 8% opacity — NOT `AppColors.accent.withOpacity(0.08)`.
