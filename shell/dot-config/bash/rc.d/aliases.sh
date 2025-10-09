# Aliases
#
# alias vim to nvim if exists
if command -v nvim &>/dev/null; then
  alias vim='nvim'
fi


alias yay-add='omarchy-pkg-aur-install'
alias yay-remove='omarchy-pkg-remove'
alias pac-add='omarchy-pkg-install'
alias pac-remove='omarchy-pkg-remove'

alias ngit='nvim +Neogit'
