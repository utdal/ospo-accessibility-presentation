# Contributing

Thank you for helping improve this project. This guide explains how the repository is organized and how to check your changes for accessibility.

## How this repository is organized

This repository teaches accessibility by showing broken code and its fixes, so it works a little differently from most projects:

- **`main` is intentionally inaccessible.** Don't fix the demo page's accessibility problems on `main`.
- **Each fix is its own branch and pull request, created from `main`.** These pull requests stay open as examples and are not merged.
- **Everything else is merged into `main` as usual.** That includes documentation, the CI workflow, tests, and templates.

## Types of contributions

### Add or improve a fix

1. Create a branch from `main` named `fix/<short-description>`, such as `fix/skip-link`.
2. Fix **one** kind of problem, so the pull request's diff is easy to follow.
3. Next to each change, add an HTML or CSS comment starting with `FIXED:` that explains what was wrong and why the fix works.
4. Keep the page looking the same unless the fix requires a visual change, such as contrast or focus styles.
5. Open a pull request and complete the accessibility checklist in the template. In the description, name the WCAG success criteria the fix addresses and whether the automated check detects it.

### Improve documentation, tests, or tooling

Branch from `main` and open a pull request as usual. These changes can be merged.

### Report a problem

Use the [accessibility issue form](https://github.com/utdal/ospo-accessibility-presentation/issues/new?template=accessibility.yml) to report a barrier in a fix or in the documentation. You don't need to explain why you need something to be accessible.

## Check accessibility before you open a pull request

Every pull request, including documentation changes, should be checked for accessibility. Automated tools catch only some problems, so do both kinds of checks.

### Automated check

The accessibility check runs automatically on every pull request. To run it locally, you need [Node.js](https://nodejs.org/) 22 or later:

```sh
npm ci
npx playwright install chromium
npm run test:a11y
```

On `main` and fix branches this check is expected to fail. Compare the list of failing rules with `main`: your change should remove violations and never add new ones that your fix causes.

### Manual checks

- **Keyboard only:** without a mouse, can you reach and use every link, button, and form field with <kbd>Tab</kbd>, <kbd>Shift</kbd>+<kbd>Tab</kbd>, <kbd>Enter</kbd>, <kbd>Space</kbd>, and <kbd>Escape</kbd>? Is focus always clearly visible, in a logical order?
- **Screen reader:** do headings, landmarks, links, buttons, and form fields announce a sensible name and role? Try NVDA, VoiceOver, or TalkBack.
- **Color and contrast:** does text meet 4.5:1 contrast (3:1 for large text, field borders, and icons)? Is meaning still clear in grayscale, using Chrome DevTools' *Rendering → Emulate vision deficiencies*?
- **Zoom and reflow:** does the page work at 200% zoom and at a narrow, phone-sized width?
- **Motion:** do any animations respect `prefers-reduced-motion`?

### Documentation

Markdown files are part of the product, too:

- Use headings in order, without skipping levels.
- Write link text that makes sense on its own. Avoid "click here".
- Give every meaningful image alt text, including status badges.
- Add a header row to tables, and don't use tables for layout.
- Specify a language on code blocks.

## Commit messages

Start the subject line with the most appropriate [gitmoji](https://gitmoji.dev/), then a verb in the third-person present tense. Keep it under 72 characters. For example:

```text
♿️ Adds a skip link to the main content
📝 Fixes a broken link in the README
```

After the subject line, write a one- or two-sentence summary, then a bulleted list of changes that use the same verb tense.
