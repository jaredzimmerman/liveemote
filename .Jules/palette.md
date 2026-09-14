## 2026-03-01 - [Demo Server Form & Audio Control Accessibility]
**Learning:** HTML `<select>` controls embedded in layout blocks without standalone `<label>` elements or visual labels, as well as `<audio>` controls and custom meeting inputs, lack accessible names for screen readers and missing focus-visible indicators for keyboard navigation.
**Action:** Always provide explicit `aria-label` attributes for unlabelled UI controls and include clear `:focus-visible` outline rules in the core CSS stylesheet for all interactive controls (`button`, `input`, `select`).
