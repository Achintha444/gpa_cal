# GPA Cal — Screen-by-Screen Redesign Plan

> Detailed specifications for every screen in the redesigned app. Reference the design system in Paper file "gpa-cal" and `docs/03-ux-research-report.md` for token values and UX rationale.

## Navigation Structure

**Bottom Tab Bar** — 3 tabs:
1. **Dashboard** — CGPA hero, semester list, quick-add FAB
2. **Analytics** — GPA trends, what-if calculator, semester comparison
3. **Settings** — Profile, GPA type, theme, export, about

**Stack Navigation** within tabs:
- Dashboard → Semester Detail → Edit Semester
- Dashboard → Add Semester (via FAB + name dialog)
- Analytics → What-If Calculator

**Modal / Sheet Navigation:**
- Set Semester Name → Bottom Sheet
- Delete Confirmation → Dialog
- Edit Semester Name → Bottom Sheet

---

## Priority 1: Foundation Screens

### 1. Splash Screen

**Purpose:** Brief brand moment (1.5s max) while checking if user is returning or new.

**User entry points:** App launch.

**Information hierarchy:**
1. App logo (centered)
2. App name "GPA Cal" (below logo)

**Layout (top to bottom):**
- Full-screen white background
- Centered: App logo (120x120dp) with subtle scale-in animation
- Below logo: "GPA Cal" in Headline weight
- No loading indicator — transition happens automatically

**States:**
- Default: Logo + name centered
- No error state needed — offline-first, no network call

**Transitions:**
- If returning user (Hive has UserDetails): Auto-navigate to Dashboard after 1.5s with fade transition
- If new user (no data): Navigate to Onboarding Step 1 with slide-right transition

**Data flow:** SplashBloc checks Hive for existing UserDetails. Emits `Authenticated(userDetails)` or `Unauthenticated`.

**Dependencies:** Hive initialization must complete before navigation decision.

---

### 2. Onboarding Flow (3 Steps)

**Purpose:** Collect user profile and create first semester in one guided flow. Research shows progress indicators improve completion by 20-43% (endowed progress effect).

**User entry points:** Auto-redirect from Splash when no user data exists.

#### Step 1: Welcome

**Layout:**
- Status bar
- Progress bar: Step 1 of 3 (33% filled, cobalt)
- Large illustration area (centered, ~200dp tall)
- Headline: "Track your academic journey"
- Body: "Calculate your GPA across semesters with support for 4.0 and 4.2 grading scales."
- Bottom: Primary button "Get Started"
- Text button below: "Already have data? Import" (future feature, disabled for V1)

**Transitions:** Tap "Get Started" → slide to Step 2.

#### Step 2: Your Profile

**Layout:**
- Progress bar: Step 2 of 3 (66% filled)
- Title Large: "About You"
- Input field: Name (text, required)
- Input field: University/School (text, required)
- GPA Type selector: Two segmented buttons [4.0] [4.2] — default 4.2
- Bottom: Primary button "Continue" (disabled until both fields filled)
- Text button: "Back"

**Validation:** Name and University cannot be empty or whitespace-only.

**Data flow:** On "Continue", SplashFormBloc saves UserDetails to Hive, emits success.

#### Step 3: Your First Semester

**Layout:**
- Progress bar: Step 3 of 3 (100% filled)
- Title Large: "Add Your First Semester"
- Input field: Semester name (e.g., "Semester 1", max 20 chars)
- Section: "Add Courses" with first CourseEntryCard pre-expanded
- CourseEntryCard contains: Course name (text input), Grade (chip selector), Credits (stepper)
- Button: "+ Add Another Course" (outlined, below course list)
- Bottom: Primary button "Finish Setup"
- Calculated SGPA shown live below course list as courses are entered

**Interactions:**
- Grade chips: single-tap to select, scrollable horizontally if needed
- Credit stepper: +/- buttons, range 0.5-10, step 0.5
- Live SGPA calculation updates on every grade/credit change
- "Finish Setup" disabled if no courses or any course has empty name

**Transitions:** On "Finish Setup" → save semester to Hive → navigate to Dashboard with fade transition. Remove all onboarding routes from stack.

**Accessibility:** All inputs have semantic labels. Grade chips have groupSemantics. Progress bar announces "Step X of 3" to screen reader.

---

### 3. Dashboard / Home

**Purpose:** Primary screen. Shows CGPA at a glance, lists all semesters, provides quick access to add new semester.

**User entry points:** Bottom tab "Dashboard" (always first tab), return from Add/Edit Semester.

**Information hierarchy:**
1. CGPA hero card (the number students care about most)
2. Trend direction (up/down/flat vs last semester)
3. Goal progress (how close to target)
4. Semester list with individual SGPAs
5. Add semester action (FAB)

**Layout (top to bottom):**
- App bar: "GPA Cal" title left, user avatar/initial circle right
- 24px padding horizontal throughout
- **CGPA Hero Card** (full width, cobalt gradient):
  - "CUMULATIVE GPA" label (12px, white 70% opacity)
  - GPA number in Display weight (40px, amber #FBBF24)
  - "/ 4.2" scale indicator (16px, white 60%)
  - Trend pill top-right: arrow + delta (e.g., "↑ +0.15" in green)
  - Goal progress bar: "Target: 3.50" label + percentage + thin bar
- 24px gap
- Trend sparkline: Mini line chart showing CGPA across semesters (subtle, 48dp tall)
- 24px gap
- Section header: "Semesters" + count badge (e.g., "Semesters · 4")
- 8px gap
- Semester card list (most recent first):
  - Each card: left accent bar (4px, cobalt) + semester name + meta (courses, credits) + SGPA (amber, large) + chevron right
  - Optional trend indicator per card (green up / red down arrow + delta)
  - Cards separated by 8px gap
- Bottom padding: 80dp (clears FAB + bottom nav)

**FAB:** Bottom-right corner, 56dp circle, cobalt background, white "+" icon. Tapping opens SetSemesterName bottom sheet.

**Components used:** GpaHeroCard, SemesterCard (list), TrendSparkline, BottomNavBar, FAB.

**States:**
- **Loading:** Skeleton shimmer on hero card + 3 placeholder semester cards
- **Success:** Full layout with data
- **Empty:** No semesters yet → EmptyStateView with illustration + "Start tracking your GPA" + "Add Your First Semester" CTA button. Hero card still shows "0.00 / 4.2"
- **Error:** Snackbar with error message + retry action. Content below still shows last-known data if available

**Interactions:**
- Tap semester card → navigate to Semester Detail
- Tap FAB → show SetSemesterName bottom sheet
- Pull-down: Not needed (offline-first, no server)
- Long-press semester card: Show context menu (Edit, Delete)

**Transitions:**
- To Semester Detail: Push with slide-right
- To Add Semester: Push after bottom sheet confirms name
- Delete semester: Confirmation dialog → remove → animate card out

**Data flow:** HomeBloc loads UserResult from SemesterRepository on init. Listens for changes after add/edit/delete operations. State contains: status, userResult (with semesters list), errorMessage.

**Dependencies:** SemesterRepository, UserDetailsRepository, GoRouter.

---

### 4. Add Semester

**Purpose:** Enter courses with grades and credits to create a new semester. This is the highest-friction screen — research says replace dropdowns with chips and use progressive disclosure.

**User entry points:** FAB on Dashboard → SetSemesterName bottom sheet → this page.

**Information hierarchy:**
1. Semester name (confirmation of what they're creating)
2. Live SGPA calculation (instant feedback)
3. Course entry forms
4. Confirm action

**Layout (top to bottom):**
- App bar: Back arrow left, "Add Semester" title, semester name as subtitle
- Live SGPA display bar: "SGPA" label + calculated value (amber, 24px bold) — updates in real-time
- 16px gap
- Section header: "Courses · {count}"
- Course entry cards (vertical list, 8px gap between):
  - Each card (full width, white bg, 16px radius, subtle shadow):
    - Course name text input (top)
    - Row: Grade chip selector (horizontal scroll) + Credit stepper (right)
    - Delete button (trash icon, top-right corner of card, 48dp touch target)
- 16px gap
- "+ Add New Course" outlined button (full width)
- 16px gap
- Bottom: "Confirm" primary button (full width, disabled if any course incomplete)

**Grade Chip Selector:** Horizontal scrollable row of chips showing all grades for the selected GPA type. A+ is pre-selected by default. Selected chip: cobalt filled, white text. Unselected: gray border, dark text.

**Credit Stepper:** − [value] + control. Default: 3. Range: 0.5–10. Step: 0.5.

**States:**
- **Editing:** Default, at least one course card visible
- **Validation error:** Empty course names highlighted with red border + error text. Confirm button disabled. Error message animated in with SlideTransition
- **Saving:** Loading overlay on Confirm button
- **Error:** Snackbar with storage error message

**Interactions:**
- Course name: Text input with autocomplete from previously entered courses
- Grade: Single-tap chip selection, immediate SGPA recalculation
- Credits: Tap +/- buttons, immediate SGPA recalculation
- Delete course: Tap trash → if only 1 course, show snackbar "At least one course required"
- Back button: Show unsaved changes dialog ("Changed details will not be saved")
- System back: Same dialog via PopScope

**Transitions:**
- Confirm → save to Hive → navigate to Dashboard (goNamed, clear stack)
- Back/Cancel with dialog confirm → pop back to Dashboard

**Data flow:** AddSemesterBloc manages: List<Subject> subjects, double sgpa (live calc), validation state. On confirm, creates Semester entity, calls SemesterRepository.addSemester(), which recalculates CGPA.

**Accessibility:** Grade chips have group semantics label "Select grade". Credit stepper announces current value. Course name inputs have "Course {n}" label.

**Dependencies:** SemesterRepository, GpaCalculator, GradeChipSelector widget, CreditStepper widget.

---

### 5. Edit Semester

**Purpose:** Modify an existing semester's courses, grades, credits, or name.

**User entry points:** Semester Detail → Edit button, or long-press semester card → Edit.

**Information hierarchy:** Same as Add Semester, but pre-populated with existing data.

**Layout:** Identical to Add Semester with these differences:
- App bar title: "Edit Semester"
- App bar action: Delete (trash icon, triggers confirmation dialog)
- All course cards pre-populated with existing course data
- "Edit Name" option: Tap semester name in subtitle → bottom sheet to rename
- Confirm button text: "Save Changes"

**States:** Same as Add Semester plus:
- **No changes:** Confirm button shows "No Changes" (disabled)
- **Delete flow:** Confirmation dialog → delete semester → navigate to Dashboard

**Data flow:** EditSemesterBloc initializes from existing Semester entity. Tracks dirty state (hasChanges). On confirm, calls SemesterRepository.editSemester(). On delete, calls SemesterRepository.deleteSemester().

**Dependencies:** Same as Add Semester + existing Semester data passed via route parameter (hash).

---

### 6. Semester Detail (New)

**Purpose:** Read-only view of a semester's courses and SGPA. Reduces accidental edits by separating viewing from editing.

**User entry points:** Tap semester card on Dashboard.

**Information hierarchy:**
1. Semester name + SGPA (hero area)
2. Course list with grades and grade points
3. Credit summary
4. Edit action

**Layout (top to bottom):**
- App bar: Back arrow, semester name as title
- SGPA display: Large number (32px, amber) + "/ 4.2" + scale label
- Divider
- Section: "Courses · {count}" + total credits badge
- Course rows (read-only, no inputs):
  - Course name (left) + grade badge (colored chip) + grade point (right, amber)
  - Separated by thin dividers
- Bottom section: Summary row showing "Total Credits: {n}" and "SGPA: {value}"
- Bottom: "Edit Semester" primary button (full width)

**States:**
- **Success:** Full layout
- **Empty:** Should not occur (semester always has ≥1 course)

**Interactions:**
- Tap "Edit Semester" → push to Edit Semester
- Swipe back / back arrow → pop to Dashboard

**Data flow:** Receives semester hash via route param, BLoC loads Semester from repository.

---

## Priority 2: Enhancement Screens

### 7. Analytics Tab

**Purpose:** GPA trends and insights over time. This is the #1 feature gap vs. top-rated competitors.

**User entry points:** Bottom tab "Analytics".

**Information hierarchy:**
1. CGPA trend chart (visual trajectory)
2. Semester comparison (best/worst)
3. Credit distribution
4. Quick link to What-If calculator

**Layout (top to bottom):**
- App bar: "Analytics" title
- **GPA Trend Chart** (full width, 200dp tall):
  - Line chart with semester labels on X-axis, GPA values on Y-axis
  - Data points at each semester with value labels
  - Subtle gradient fill below the line (cobalt → transparent)
  - Y-axis range: 0 to max GPA scale (4.0 or 4.2)
- 24px gap
- **Summary Cards Row** (horizontal scroll, 2 cards visible):
  - "Best Semester" card: name + SGPA (green accent)
  - "Lowest Semester" card: name + SGPA (amber accent)
  - "Total Credits" card: total credit count
  - "Avg Credits/Sem" card: average
- 24px gap
- **What-If CTA Card:**
  - "What grades do I need?" headline
  - "Calculate what you need to reach your target GPA" body
  - "Try What-If →" button
- 24px gap
- **Per-Semester Breakdown** (expandable list):
  - Each row: Semester name + SGPA + credit count
  - Tap to expand: shows individual course grades

**States:**
- **Insufficient data:** Fewer than 2 semesters → show illustration + "Add more semesters to unlock analytics" + back-to-dashboard CTA
- **Success:** Full chart + summary
- **Loading:** Skeleton chart + placeholder cards

**Data flow:** AnalyticsBloc computes trend data, best/worst, averages from UserResult.

**Dependencies:** Requires charting solution (fl_chart or similar — needs user approval to add dependency). SemesterRepository.

---

### 8. What-If Calculator (New)

**Purpose:** Goal-seek — "What grades do I need next semester to reach target CGPA?" The #1 differentiator of 4.9-star apps.

**User entry points:** Analytics tab → "Try What-If" CTA, or bottom sheet shortcut.

**Information hierarchy:**
1. Current CGPA (starting point)
2. Target CGPA (user input)
3. Projected courses for next semester
4. Required grades calculation

**Layout (top to bottom):**
- App bar: Back arrow, "What-If Calculator" title
- Current state card: "Your CGPA: 3.42 / 4.2" + "Total Credits: 45"
- 24px gap
- Target input: "Target CGPA" label + text input (numeric, 0.00-4.20 range) + slider alternative
- 24px gap
- "Next Semester" section:
  - Number of courses slider/stepper (1-8)
  - Expected credits per course (stepper, default 3)
- 24px gap
- **Result Card** (dynamic, updates live):
  - "You need an average grade of:" + large grade display (e.g., "B+" in amber)
  - Or: "Target is achievable with all A grades" (green)
  - Or: "Target is not achievable in one semester" (red, with explanation)
- Explanation text: Shows the math briefly

**States:**
- **Input:** Waiting for target GPA input
- **Calculated:** Showing result
- **Impossible:** Target not reachable (red state with friendly message)

**Interactions:** All inputs trigger live recalculation (debounced 300ms).

**Data flow:** WhatIfBloc takes current CGPA + total credits as input, computes required grade average based on target and projected credits.

---

### 9. Empty States

**Purpose:** Every screen has a designed empty state with illustration + message + CTA.

**Dashboard (no semesters):**
- Illustration: notebook/graduation cap icon (48dp, cobalt accent)
- Headline: "Start tracking your GPA"
- Body: "Your academic journey begins with one semester."
- CTA: "Add Your First Semester" primary button

**Semester Detail (no courses) — should not occur but defensive:**
- Body: "No courses in this semester"
- CTA: "Add Courses"

**Analytics (fewer than 2 semesters):**
- Illustration: chart icon with dashed lines
- Headline: "Need more data"
- Body: "Add at least 2 semesters to see your GPA trends."
- CTA: "Back to Dashboard"

---

## Priority 3: Polish Screens

### 10. Settings

**Purpose:** User profile, preferences, and app management.

**User entry points:** Bottom tab "Settings".

**Layout (top to bottom):**
- App bar: "Settings" title
- **Profile section:**
  - User avatar/initial circle (64dp) + Name + University
  - "Edit Profile" text button → bottom sheet with name/uni fields
- Divider
- **Preferences section:**
  - GPA Scale: Segmented control [4.0] [4.2] (changes affect all future calculations)
  - Theme: Segmented control [Light] [Dark] [System]
- Divider
- **Data section:**
  - "Export as PDF" row with chevron
  - "Clear All Data" row (red text, triggers confirmation dialog)
- Divider
- **About section:**
  - App version
  - Privacy Policy link
  - Open source licenses

**Interactions:**
- GPA scale change: Confirmation dialog warning this affects all calculations
- Theme change: Immediate, no confirmation needed
- Clear all data: Double confirmation (dialog + type "DELETE" to confirm)

---

### 11. Export / Share

**Purpose:** Generate a PDF transcript summary for sharing with academic advisors.

**User entry points:** Settings → "Export as PDF", or share button on Dashboard.

**Layout:**
- Preview of generated PDF (scrollable)
- Bottom: "Share" button (opens system share sheet) + "Save to Files" button

**PDF Content:**
- Header: Student name, university, GPA type
- CGPA summary with goal progress
- Per-semester breakdown: name, SGPA, course table (course, grade, credits, grade points)
- Footer: "Generated by GPA Cal" + date

**Dependencies:** PDF generation package (needs user approval). Share functionality via system sheet.

---

## Cross-Cutting Concerns

### Bottom Sheet: Set Semester Name
- Height: ~220dp
- Content: "Set Semester Name" title + text input (max 20 chars) + character counter + Cancel/Set Name buttons
- Validation: Cannot be empty, max 20 chars
- Used by: Dashboard FAB flow, Edit Semester rename

### Confirmation Dialog
- Height: ~220dp
- Content: Warning icon (red) + "IMPORTANT!" title + description text + Cancel/OK buttons
- Variants: Delete semester, discard changes, clear all data

### Snackbar
- Position: Bottom, above bottom nav
- Variants: Error (red bg), Info (cobalt bg), Success (green bg)
- Action button: "CLEAR" or "RETRY" or "UNDO"

---

## Screen Dependency Graph

```
Splash
  ├── [new user] → Onboarding (1→2→3) → Dashboard
  └── [returning] → Dashboard

Dashboard
  ├── → Semester Detail → Edit Semester → Dashboard
  ├── → Add Semester → Dashboard
  └── Tab: Analytics
         └── → What-If Calculator

Tab: Settings
  └── → Export/Share
```

## Build Order

| Phase | Screens | Rationale |
|-------|---------|-----------|
| 1 | Splash, Onboarding, Dashboard, Add Semester | Core loop: launch → setup → view → add |
| 2 | Edit Semester, Semester Detail | Complete CRUD operations |
| 3 | Analytics, What-If Calculator | Differentiation features |
| 4 | Settings, Export | Polish and preferences |
| 5 | Empty States (all), Error States (all) | Edge case coverage |
