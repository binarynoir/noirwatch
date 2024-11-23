# Brewfile for NoirWatch project

# Install bash
brew install bash

# Custom script setup
system "curl -o /usr/local/bin/noirwatch https://raw.githubusercontent.com/binarynoir/noirwatch/main/noirwatch"
system "chmod +x /usr/local/bin/noirwatch"

# Install the man page
system "curl -o /usr/local/share/man/man1/noirwatch.1 https://raw.githubusercontent.com/binarynoir/noirwatch/main/noirwatch.1"
system "man -c /usr/local/share/man/man1/noirwatch.1"
