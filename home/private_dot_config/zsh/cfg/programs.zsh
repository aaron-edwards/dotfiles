if type nvim > /dev/null; then
  export EDITOR=nvim
fi
if type zoxide > /dev/null; then
  eval "$(zoxide init zsh)"
fi

. /opt/asdf-vm/asdf.sh

