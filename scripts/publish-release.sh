#!/usr/bin/env bash

APP_SCRIPT="noirwatch"

# Extract the version number from the application script
VERSION=$(grep -Eo 'VERSION=[0-9]+\.[0-9]+\.[0-9]+' $APP_SCRIPT | cut -d '=' -f 2)

# Check if the version number was found
if [ -z "$VERSION" ]; then
    echo "Version number not found in $APP_SCRIPT script."
    exit 1
fi

# Ensure repo is up-to-date
git pull

# Create an annotated tag
git tag -a "v$VERSION" -m "v$VERSION"

# Push all tags to the repository
git push --tags

echo "Tag v$VERSION created and pushed to the repository."
