#!/bin/sh
set -e

printf "\033[0;32mBootstrapping Neovim\033[0m\n"

if ! command -v nvim > /dev/null 2>&1; then
    echo "Neovim not found, skipping bootstrap"
    exit 0
fi

echo "Bootstrapping Neovim plugins (lazy.nvim)..."
nvim --headless "+Lazy! sync" +qa
echo "Neovim bootstrap complete"
