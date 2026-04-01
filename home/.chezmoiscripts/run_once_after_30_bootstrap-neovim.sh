#!/bin/sh
set -e

if ! command -v nvim > /dev/null 2>&1; then
    echo "Neovim not found, skipping bootstrap"
    exit 0
fi

echo "Bootstrapping Neovim plugins (lazy.nvim)..."
nvim --headless "+Lazy! sync" +qa
echo "Neovim bootstrap complete"
