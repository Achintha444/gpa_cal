---
name: crud-routing
description: How gpaType, semester hash, and semester name are passed between home/add/edit/detail routes via GoRouter extras and path parameters
metadata:
  type: project
---

## CRUD Screen Routing Conventions

### Route parameters
- `semesterHash` → path parameter `:hash` (parsed with `int.tryParse`)
- `semesterName` → route extra `Map<String, dynamic>` key `'name'`
- `gpaType` → route extra `Map<String, dynamic>` key `'gpaType'` (defaults to `0`)

### Navigation chain
```
Home → (semester name sheet) → /add-semester  extra: {name, gpaType}
Home → /semester-detail/:hash                 extra: {gpaType}
SemesterDetail → /edit-semester/:hash         extra: {gpaType}
```

### After mutations (add/edit/delete)
Always dispatch `HomeDataRequested` to the app-level `HomeBloc` BEFORE navigating, so the dashboard reflects the change immediately:

```dart
ctx.read<HomeBloc>().add(const HomeDataRequested());
ctx.goNamed(AppRoutes.home); // or Navigator.of(ctx).pop()
```

### HomePage reload on mount
`HomePage` is a `StatefulWidget`. `initState` dispatches `HomeDataRequested` so data is always fresh when the branch is first activated.

**Why:** `StatefulShellRoute.indexedStack` keeps the home widget alive. Without the `initState` dispatch, returning to home after a mutation (via pop instead of goNamed) would show stale data.

Related: [[app-level-blocs]]
