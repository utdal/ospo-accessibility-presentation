# Digital Accessibility for Open Source Developers

![Accessibility checks workflow status for the main branch](https://github.com/utdal/ospo-accessibility-presentation/actions/workflows/accessibility.yml/badge.svg?branch=main)

Companion repository for the *Digital Accessibility for Open Source Developers* presentation by the [Open Source Program Office at The University of Texas at Dallas](https://opensource.utdallas.edu/) (UTD-OSPO).

It contains a small web page for a fictional open source project, **OpenLab**, that is **deliberately inaccessible**. Each accessibility problem is fixed in its own pull request, so you can see the code change, the reasoning, and how automated accessibility checks respond.

> **The `main` branch is broken on purpose.** Its accessibility check is expected to fail. The fixes live in open pull requests and are not meant to be merged.

## How this repository works

- [`deliberately-inaccessible.html`](deliberately-inaccessible.html) on `main` is the "before" version. HTML comments mark each problem.
- Every fix is a separate branch created from `main`, with one open pull request. Each pull request changes only what that fix needs, and comments starting with `FIXED:` explain why.
- A [GitHub Actions workflow](.github/workflows/accessibility.yml) runs [axe-core](https://github.com/dequelabs/axe-core) on every push and pull request. Open a pull request's **Checks** tab and choose the job summary to see which rules still fail.

## The fixes

| Fix | WCAG 2.2 success criteria | What the automated check shows |
| --- | --- | --- |
| [Semantic landmarks, headings, and navigation (PR #1)](https://github.com/utdal/ospo-accessibility-presentation/pull/1) | 1.3.1 Info and Relationships, 2.1.1 Keyboard | Resolves `landmark-one-main`, `page-has-heading-one`, and `region`. Does not detect the clickable `div` navigation that was also fixed. |
| [Meaningful alt text for the activity chart (PR #2)](https://github.com/utdal/ospo-accessibility-presentation/pull/2) | 1.1.1 Non-text Content | Resolves `image-alt`. Only checks that alt text exists, not whether it is useful. |
| [Text and control contrast (PR #3)](https://github.com/utdal/ospo-accessibility-presentation/pull/3) | 1.4.3 Contrast (Minimum), 1.4.11 Non-text Contrast | Resolves `color-contrast`. Does not check form field border contrast, which was also fixed. |
| [Visible, programmatic form labels (PR #4)](https://github.com/utdal/ospo-accessibility-presentation/pull/4) | 1.3.1 Info and Relationships, 3.3.2 Labels or Instructions, 4.1.2 Name, Role, Value | Resolves `label` and `select-name`. |
| [Project status that doesn't rely on color (PR #5)](https://github.com/utdal/ospo-accessibility-presentation/pull/5) | 1.4.1 Use of Color | No change: automated checks can't detect this problem. |

Planned fixes include keyboard operation and visible focus, a skip link, descriptive link text, the page language, accessible form validation, and an accessible dialog.

## Automated testing finds only some problems

Automated tools are fast and catch regressions, but they can't judge meaning. In this repository, two of the five fixes so far include problems that axe-core does not report at all. Always combine automated checks with manual testing:

- **Keyboard:** unplug your mouse. Use <kbd>Tab</kbd> and <kbd>Shift</kbd>+<kbd>Tab</kbd> to move, and <kbd>Enter</kbd> or <kbd>Space</kbd> to activate. Focus should always be visible.
- **Screen reader:** try [NVDA](https://www.nvaccess.org/download/) on Windows, VoiceOver on macOS and iOS, or TalkBack on Android.
- **Visual checks:** zoom to 200%, and use Chrome DevTools' *Rendering → Emulate vision deficiencies* to check that color isn't the only way meaning is shown.
- **Browser extensions:** [WAVE](https://wave.webaim.org/) and [Silktide](https://silktide.com/toolbar/) highlight issues directly on the page.

## Run it yourself

To view the page, open `deliberately-inaccessible.html` in a web browser. Switch branches to see each fix.

To run the automated accessibility check locally, you need [Node.js](https://nodejs.org/) 22 or later:

```sh
npm ci
npx playwright install chromium
npm run test:a11y
```

The check fails and lists each rule that was violated, with the number of affected elements.

## Learn more

- [Web Content Accessibility Guidelines (WCAG) 2.2](https://www.w3.org/TR/WCAG22/)
- [Introduction to understanding WCAG](https://www.w3.org/WAI/WCAG22/Understanding/intro), including the four principles: perceivable, operable, understandable, and robust
- [ARIA Authoring Practices Guide patterns](https://www.w3.org/WAI/ARIA/apg/patterns/)
- [GOV.UK Design System components](https://design-system.service.gov.uk/components/)
- [Scott O'Hara's accessible components](https://github.com/scottaohara/accessible_components)
- [axe-core](https://github.com/dequelabs/axe-core) and [GitHub's accessibility scanner](https://github.com/github/accessibility-scanner)

## Contributing

Contributions are welcome. Read the [contributing guide](CONTRIBUTING.md) for how this repository is organized and how to check your changes for accessibility. To report an accessibility problem, [open an accessibility issue](https://github.com/utdal/ospo-accessibility-presentation/issues/new?template=accessibility.yml).

## License

Released under the [MIT License](LICENSE).
