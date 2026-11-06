#!/usr/bin/env bash
#
# Builds the GitHub Pages site: one folder per branch containing that
# branch's version of the demo page, plus an accessible landing page.
#
# Files are read straight from git with `git show`, so no branch is
# checked out and nothing from a fix branch is ever executed.
#
# Usage: .github/scripts/build-pages.sh [output-dir]   (default: _site)

set -euo pipefail

OUT="${1:-_site}"
PAGE="deliberately-inaccessible.html"
REPO="${GITHUB_REPOSITORY:-utdal/ospo-accessibility-presentation}"
REPO_URL="https://github.com/${REPO}"

# Prefer remote-tracking branches (CI); fall back to local ones.
if git show-ref --quiet "refs/remotes/origin/main"; then
  PREFIX="refs/remotes/origin"
else
  PREFIX="refs/heads"
fi

escape_html() {
  sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' -e 's/"/\&quot;/g'
}

# Drops a leading gitmoji (e.g. "♿️ "), which screen readers would announce
# at the start of every heading ("wheelchair symbol").
strip_gitmoji() {
  LC_ALL=C sed -E 's/^[^[:alnum:]]+ //'
}

rm -rf "$OUT"
mkdir -p "$OUT"
items=""

# Copies one branch's page into its own folder and adds a list item for it.
add_version() {
  local branch="$1" label="$2" description="$3"
  local ref="${PREFIX}/${branch}"
  local dir="${branch//\//-}"

  if ! git cat-file -e "${ref}:${PAGE}" 2>/dev/null; then
    echo "Skipping ${branch}: ${PAGE} not found." >&2
    return
  fi

  mkdir -p "${OUT}/${dir}"
  git show "${ref}:${PAGE}" > "${OUT}/${dir}/index.html"
  echo "Added ${branch} -> ${dir}/" >&2

  items+="
        <li>
          <h3><a href=\"${dir}/\">${label}</a></h3>${description:+
          <p>${description}</p>}
          <p class=\"meta\">Branch: <code>${branch}</code> &middot;
            <a href=\"${REPO_URL}/tree/${branch}\">View the <code>${branch}</code> source on GitHub</a></p>
        </li>"
}

add_version "main" \
  "Before: the deliberately inaccessible page" \
  "The original page, with every accessibility problem still in place."

# Fix branches, oldest first. Each is described by its latest commit subject.
while IFS= read -r ref; do
  branch="${ref#"${PREFIX}/"}"
  subject="$(git log -1 --format=%s "$ref" | strip_gitmoji | escape_html)"
  add_version "$branch" "$subject" ""
done < <(git for-each-ref --sort=committerdate --format='%(refname)' "${PREFIX}/fix/")

cat > "${OUT}/index.html" <<HTML
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Accessibility demo versions | OpenLab</title>
  <style>
    :root {
      --text: #1f1f1f;
      --muted: #4a4a4a;
      --link: #154734;
      --bg: #ffffff;
      --panel: #f4f4f4;
      --focus: #0b57d0;
    }

    body {
      margin: 0;
      padding: 0 1rem;
      font-family: system-ui, -apple-system, "Segoe UI", Roboto, Arial, sans-serif;
      line-height: 1.5;
      color: var(--text);
      background: var(--bg);
    }

    main {
      max-width: 46rem;
      margin: 0 auto;
      padding-block: 2rem 3rem;
    }

    a {
      color: var(--link);
    }

    a:focus-visible {
      outline: 3px solid var(--focus);
      outline-offset: 2px;
    }

    .notice {
      padding: 0.75rem 1rem;
      border-left: 4px solid var(--link);
      background: var(--panel);
    }

    ul {
      padding: 0;
      list-style: none;
    }

    li {
      margin-bottom: 1rem;
      padding: 1rem;
      border: 1px solid #767676;
      border-radius: 6px;
    }

    li h3 {
      margin: 0 0 0.25rem;
      font-size: 1.15rem;
    }

    li p {
      margin: 0.25rem 0;
    }

    .meta {
      color: var(--muted);
      font-size: 0.9rem;
    }

    @media (prefers-reduced-motion: no-preference) {
      html {
        scroll-behavior: smooth;
      }
    }
  </style>
</head>
<body>
  <main>
    <h1>Digital Accessibility for Open Source Developers</h1>

    <p>
      Live demo pages from the presentation by the
      <a href="https://opensource.utdallas.edu/">Open Source Program Office
      at The University of Texas at Dallas</a> (UTD-OSPO).
    </p>

    <p class="notice">
      <strong>The first page is broken on purpose.</strong>
      Each page after it applies just one fix to the original, and the
      other problems remain. Compare a fix with the original to see what
      changed.
    </p>

    <h2>Page versions</h2>
    <ul>${items}
    </ul>

    <h2>About this project</h2>
    <p>
      Read the code, the pull requests, and the automated accessibility
      check results in the
      <a href="${REPO_URL}">ospo-accessibility-presentation repository on GitHub</a>.
    </p>
  </main>
</body>
</html>
HTML

echo "Built site in ${OUT}/" >&2
