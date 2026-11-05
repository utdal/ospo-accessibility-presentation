// @ts-check
const fs = require("node:fs");
const path = require("node:path");
const { pathToFileURL } = require("node:url");
const { test, expect } = require("@playwright/test");
const { AxeBuilder } = require("@axe-core/playwright");

const PAGES = ["deliberately-inaccessible.html"];

// WCAG 2.2 A/AA rules, plus axe "best practices" (landmarks, headings, etc.).
const TAGS = [
  "wcag2a",
  "wcag2aa",
  "wcag21a",
  "wcag21aa",
  "wcag22aa",
  "best-practice",
];

/** Write a Markdown table of violations to the GitHub Actions job summary. */
function writeSummary(page, violations) {
  const file = process.env.GITHUB_STEP_SUMMARY;
  if (!file) return;

  const lines = [`## axe-core results: \`${page}\``, ""];

  if (violations.length === 0) {
    lines.push("No violations found. (Automated tools catch only some issues: test manually too.)");
  } else {
    const total = violations.reduce((n, v) => n + v.nodes.length, 0);
    lines.push(`**${violations.length} rules failed** across **${total} elements**.`, "");
    lines.push("| Impact | Rule | Elements | Description |");
    lines.push("| --- | --- | ---: | --- |");
    for (const v of violations) {
      lines.push(
        `| ${v.impact} | [\`${v.id}\`](${v.helpUrl}) | ${v.nodes.length} | ${v.help.replace(/\|/g, "\\|")} |`
      );
    }
  }

  fs.appendFileSync(file, lines.join("\n") + "\n\n");
}

for (const pageFile of PAGES) {
  test(`${pageFile} has no detectable accessibility violations`, async ({ page }) => {
    const url = pathToFileURL(path.join(__dirname, "..", pageFile)).href;
    await page.goto(url);

    const { violations } = await new AxeBuilder({ page }).withTags(TAGS).analyze();

    writeSummary(pageFile, violations);

    // Readable list in the console log, one line per rule.
    const report = violations
      .map((v) => `  [${v.impact}] ${v.id} (${v.nodes.length}): ${v.help}`)
      .join("\n");

    expect(
      violations.map((v) => v.id),
      `Accessibility violations:\n${report}\n`
    ).toEqual([]);
  });
}
