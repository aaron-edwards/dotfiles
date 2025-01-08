if type eza > /dev/null; then
  alias ls="eza"
else 
  alias ls="ls --color"
fi
alias ll="ls -la"
