# Pull Request — ready to paste into GitHub

**Repository:** `opencollective/opencollective-frontend`
**Base:** `main`
**Head:** `fix/close-profile-menu-on-preview-features-modal`

---

## Title

```
fix(ProfileMenu): close the menu when opening the Preview Features modal
```

---

## Body

```markdown
Closes opencollective/opencollective#7143

### Problem

Opening **Preview Features** from the profile menu left the menu open behind the
modal, which is inconsistent with every other entry in that menu (profile links
navigate and close it, and `ProfileMenuMemberships` already calls `closeDrawer`).

The menu could not simply be closed on click, because `PreviewFeaturesModal` was
rendered *inside* the `content` block that gets passed to `PopoverContent` /
`DrawerMenu`. Closing the menu unmounted its subtree, and the modal went with it.

### Fix

Two changes in `components/navigation/ProfileMenu.tsx`:

1. Move `<PreviewFeaturesModal />` out of `content` and render it as a sibling of
   the `Popover` / `DrawerMenu`, so its lifetime is independent of the menu. This
   is the pattern Radix recommends for dialogs triggered from a popover or
   dropdown.
2. Close the menu in the menu item's `onClick`, alongside opening the modal.

```diff
                 <MenuItem
                   Icon={FlaskConical}
-                  onClick={() => setShowPreviewFeaturesModal(true)}
+                  onClick={() => {
+                    setMenuOpen(false);
+                    setShowPreviewFeaturesModal(true);
+                  }}
```

### Note on the "News and Updates" modal

The issue also mentions the News and Updates modal. That one is no longer opened
from the profile menu — `ChangelogTrigger` is now a sibling of `ProfileMenu` in
`TopBar` and `DashboardTopbar` with its own button, so it is unaffected. Only the
Preview Features case still reproduced.

### Testing

Added `components/navigation/ProfileMenu.test.tsx`, which opens the menu, clicks
**Preview Features**, and asserts the modal appears while the menu is gone. It
fails on `main` and passes with this change.

```
npx jest components/navigation/ProfileMenu.test.tsx
```

Also verified: `prettier --check`, `eslint` (0 errors — the one remaining warning
on line 128 is pre-existing and untouched), and `tsc --noEmit` all clean.
```

---

## Verification performed

| Check | Command | Result |
|---|---|---|
| Formatting | `npx prettier --check components/navigation/ProfileMenu*.tsx` | pass |
| Lint | `npx eslint components/navigation/ProfileMenu*.tsx` | 0 errors (1 pre-existing warning on untouched line 128) |
| Types | `npx tsc --noEmit -p tsconfig.json` | no errors in changed files |
| Unit test | `npx jest components/navigation/ProfileMenu.test.tsx` | 1 passed |
| Regression proof | same test against unpatched `ProfileMenu.tsx` | **fails** — confirms it tests the real bug |

Not verified: the change was not exercised in a running browser. The logic and
render tree are covered by the jsdom test above, but a quick manual click-through
against staging is worth doing before merge.

---

## How to open the PR

You need your own fork of **`opencollective-frontend`** — your existing fork is of
`opencollective/opencollective`, which is the issue tracker, not this codebase.

1. Fork `https://github.com/opencollective/opencollective-frontend` on GitHub.

2. Clone it and create the branch:

```bash
git clone https://github.com/<your-username>/opencollective-frontend.git
cd opencollective-frontend
git remote add upstream https://github.com/opencollective/opencollective-frontend.git
git checkout -b fix/close-profile-menu-on-preview-features-modal
```

3. Apply the patch (it carries the commit message and authorship):

```bash
git am /path/to/fix-7143-close-profile-menu.patch
```

If `git am` complains, use the plain diff instead and commit manually:

```bash
git apply /path/to/fix-7143-close-profile-menu.patch
git add components/navigation/ProfileMenu.tsx components/navigation/ProfileMenu.test.tsx
git commit -m "fix(ProfileMenu): close the menu when opening the Preview Features modal"
```

4. Optional but recommended — run the checks yourself. Note the repo requires
   **Node 24.x**:

```bash
nvm install && nvm use
npm ci
npx jest components/navigation/ProfileMenu.test.tsx
npm run prettier:check
```

5. Push and open the PR against `opencollective/opencollective-frontend:main`:

```bash
git push origin fix/close-profile-menu-on-preview-features-modal
```

Use the title and body above. Keep `Closes opencollective/opencollective#7143`
in the body — cross-repo closing keywords work, and this repo's issues live in
the other repo.
