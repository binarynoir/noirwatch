#!/usr/bin/env bash

# Tag the version in the application script and push the tag.
# Pushing the tag starts the release workflow, which runs CI, creates the
# GitHub release and updates the Homebrew formula.

set -euo pipefail

APP_SCRIPT="noirwatch"

cd "$(dirname "$0")/.."

# Extract the version number from the application script
VERSION=$(grep -Eo '^(readonly )?VERSION=[0-9]+\.[0-9]+\.[0-9]+' "$APP_SCRIPT" | cut -d= -f2)
if [[ -z "$VERSION" ]]; then
    echo "Version number not found in $APP_SCRIPT script." >&2
    exit 1
fi
TAG="v$VERSION"

# Only release committed work from main
if [[ -n "$(git status --porcelain)" ]]; then
    echo "Commit or stash your changes before releasing." >&2
    exit 1
fi

branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$branch" != "main" ]]; then
    echo "Releases are made from main (current branch: $branch)." >&2
    exit 1
fi

# Ensure repo is up-to-date
git pull --ff-only

if git rev-parse -q --verify "refs/tags/$TAG" >/dev/null; then
    echo "Tag $TAG already exists. Update VERSION in $APP_SCRIPT first." >&2
    exit 1
fi

if ! grep -q "^## \[$VERSION\]" CHANGELOG.md; then
    echo "CHANGELOG.md has no entry for $VERSION." >&2
    exit 1
fi

# Create an annotated tag and push only that tag
git tag -a "$TAG" -m "$TAG"
git push origin "$TAG"

echo "Tag $TAG created and pushed to the repository."
