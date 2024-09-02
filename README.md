# Aaron's Dot Files

[Chezmoi](https://www.chezmoi.io/) Managed dotfiles for
- zsh
- tmux
- alacritty

## Requirements

**Note:** The onchange script will attempt to install dependacies
 
- zsh
    - [antidote](https://getantidote.github.io/)
        - Arch `yay -S zsh-antidote`
        - Mac `brew install antidote`
    - eza (optional)
    - zoxide (optional)
    - fzf (optional)
    - [alacitty](https://github.com/mattmc3/antidote)
    - tmux
        - The alacritty config assumes tmux will be installed in /usr/bin in linux or /opt/homebrew/bin/ on mac
        - Arch `pacman -S tmux`
        - Mac `brew install tmux`
    - Powerline patched [Monaspace](https://github.com/githubnext/monaspace) (monaspice)
        - Arch: `pacman -S otf-monaspace-nerd`
- tmux
