#!/usr/bin/env bash

# Extract the version number from the noirwatch script
VERSION=$(grep -Eo 'VERSION=[0-9]+\.[0-9]+\.[0-9]+' noirwatch | cut -d '=' -f 2)

# Check if the version number was found
if [ -z "$VERSION" ]; then
    echo "Version number not found in noirwatch script."
    exit 1
fi

REPO="binarynoir/noirwatch"

# Ensure repo is up-to-date
git pull

# Create an annotated tag
git tag -a "v$VERSION" -m "v$VERSION"

# Push all tags to the repository
git push --tags

echo "Tag v$VERSION created and pushed to the repository."
