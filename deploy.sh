#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

GH="${GH:-gh}"
if ! command -v gh >/dev/null 2>&1; then
  GH="/tmp/gh-install/gh_2.69.0_macOS_arm64/bin/gh"
fi

if ! "$GH" auth status >/dev/null 2>&1; then
  echo "GitHub login is required."
  "$GH" auth login -h github.com -p https -w
fi

REPO_NAME="${REPO_NAME:-minseo-portfolio}"
OWNER="$("$GH" api user -q .login)"

if git remote get-url origin >/dev/null 2>&1; then
  echo "Remote origin already exists."
else
  "$GH" repo create "$REPO_NAME" --public --source=. --remote=origin --push --description "Kim Min Seo portfolio site"
fi

git push -u origin main

"$GH" api -X POST "/repos/${OWNER}/${REPO_NAME}/pages" \
  -f build_type=legacy \
  -f "source[branch]=main" \
  -f "source[path]=/" \
  >/dev/null 2>&1 || true

echo
echo "Repository: https://github.com/${OWNER}/${REPO_NAME}"
echo "Live site:  https://${OWNER}.github.io/${REPO_NAME}/"
echo
echo "GitHub Pages may take 1-2 minutes to become available."
