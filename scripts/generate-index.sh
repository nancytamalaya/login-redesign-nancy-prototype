#!/usr/bin/env bash
set -euo pipefail

# Generates index.html in the current directory by scanning for deployed
# prototype subdirectories (identified by containing an index.html file).
# Intended to run inside the gh-pages worktree.

ts="$(date -u '+%Y-%m-%d %H:%M UTC')"
found=0
rows=""

for dir in */; do
  [ -d "$dir" ] || continue
  slug="${dir%/}"
  [ -f "${slug}/index.html" ] || continue

  # Strip cursor- prefix for display if present
  display="${slug#cursor-}"

  rows="${rows}<li><a href=\"${slug}/\" class=\"card\"><span class=\"project\">${display}</span><span class=\"open\">Open</span></a></li>\n"
  found=$((found + 1))
done

cat > index.html <<'HTML_HEAD'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>ACCloud Prototypes</title>
  <style>
    :root {
      --logo-blue: #101a5c;
      --deep-blue: #08193e;
      --vivid-blue: #113cca;
      --light-blue: #1d5eed;
      --vivid-orange: #f37021;
      --gold: #ffaa05;
      --white: #ffffff;
      --bg: #fcfcfc;
      --grey: #dadadf;
      --text-secondary: #6b7280;
      --text-muted: #9ca3af;
      --radius: 8px;
    }

    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
      font-family: Calibre, -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
      color: var(--deep-blue);
      background: var(--bg);
      min-height: 100vh;
      -webkit-font-smoothing: antialiased;
    }

    .header {
      background: var(--deep-blue);
      color: var(--white);
      padding: 2.5rem 2rem 2rem;
    }

    .header-inner {
      max-width: 760px;
      margin: 0 auto;
    }

    .header h1 {
      font-size: 1.375rem;
      font-weight: 600;
      letter-spacing: -0.01em;
      margin-bottom: 0.375rem;
    }

    .header p {
      font-size: 0.8125rem;
      color: rgba(255, 255, 255, 0.6);
      font-weight: 400;
    }

    .accent-bar {
      height: 3px;
      background: linear-gradient(90deg, var(--vivid-orange), var(--gold));
    }

    .content {
      max-width: 760px;
      margin: 0 auto;
      padding: 2rem 1.5rem;
    }

    .section-label {
      font-size: 0.6875rem;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.06em;
      color: var(--text-secondary);
      margin-bottom: 0.75rem;
    }

    .list {
      list-style: none;
      display: flex;
      flex-direction: column;
      gap: 0.5rem;
    }

    .card {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 1rem;
      padding: 0.875rem 1.125rem;
      background: var(--white);
      border: 1px solid var(--grey);
      border-radius: var(--radius);
      text-decoration: none;
      color: var(--deep-blue);
      transition: border-color 0.15s, box-shadow 0.15s;
    }

    .card:hover {
      border-color: var(--light-blue);
      box-shadow: 0 2px 8px rgba(29, 94, 237, 0.08);
    }

    .card:hover .project {
      color: var(--light-blue);
    }

    .project {
      font-size: 0.9375rem;
      font-weight: 500;
      transition: color 0.15s;
    }

    .open {
      font-size: 0.75rem;
      font-weight: 500;
      color: var(--text-secondary);
      white-space: nowrap;
    }

    .card:hover .open {
      color: var(--light-blue);
    }

    .empty-state {
      text-align: center;
      padding: 3rem 1.5rem;
      background: var(--white);
      border: 1px dashed var(--grey);
      border-radius: var(--radius);
    }

    .empty-state h2 {
      font-size: 1rem;
      font-weight: 600;
      color: var(--deep-blue);
      margin-bottom: 0.5rem;
    }

    .empty-state p {
      font-size: 0.8125rem;
      color: var(--text-secondary);
      max-width: 420px;
      margin: 0 auto;
      line-height: 1.5;
    }

    .empty-state code {
      font-size: 0.75rem;
      background: rgba(17, 60, 202, 0.06);
      color: var(--vivid-blue);
      padding: 0.15rem 0.4rem;
      border-radius: 4px;
    }

    .footer {
      max-width: 760px;
      margin: 1.5rem auto 2rem;
      padding: 0 1.5rem;
      font-size: 0.6875rem;
      color: var(--text-muted);
      text-align: center;
    }
  </style>
</head>
<body>
  <div class="header">
    <div class="header-inner">
      <h1>ACCloud Prototypes</h1>
      <p>Interactive prototypes auto-deployed from Cursor Cloud</p>
    </div>
  </div>
  <div class="accent-bar"></div>
  <div class="content">
HTML_HEAD

if [ "$found" -eq 0 ]; then
  cat >> index.html <<'HTML_EMPTY'
    <div class="empty-state">
      <h2>No prototypes yet</h2>
      <p>Create a new Cursor branch with the <code>cursor/</code> prefix and push it to GitHub to see it appear here.</p>
    </div>
HTML_EMPTY
else
  echo '    <p class="section-label">Active prototypes</p>' >> index.html
  echo '    <ul class="list">' >> index.html
  printf '%b' "$rows" >> index.html
  echo '    </ul>' >> index.html
fi

cat >> index.html <<HTML_FOOT
  </div>
  <p class="footer">Last updated ${ts} &middot; ${found} prototype(s)</p>
</body>
</html>
HTML_FOOT
