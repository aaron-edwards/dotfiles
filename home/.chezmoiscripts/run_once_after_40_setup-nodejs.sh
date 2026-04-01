#!/bin/sh
set -e

if ! command -v asdf > /dev/null 2>&1; then
    echo "asdf not found, skipping Node.js setup"
    exit 0
fi

# Add nodejs plugin if not already present
if ! asdf plugin list 2>/dev/null | grep -q "^nodejs$"; then
    echo "Adding asdf nodejs plugin..."
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
fi

# Resolve latest LTS version from the Node.js release index
echo "Resolving latest Node.js LTS version..."
LTS_VERSION=$(curl -sf https://nodejs.org/dist/index.json \
    | jq -r '[.[] | select(.lts != false)] | first | .version[1:]')

echo "Installing Node.js LTS ($LTS_VERSION)..."
asdf install nodejs "$LTS_VERSION"
asdf set -u nodejs "$LTS_VERSION"

# Enable corepack (yarn/pnpm shims) and reshim so asdf picks them up
corepack enable
asdf reshim nodejs

echo "Node.js $LTS_VERSION installed with corepack enabled"
