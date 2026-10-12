# Created by newuser for 5.9
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# opencode
export PATH=/home/k4rl0z/.opencode/bin:$PATH
export PATH="$HOME"/.local/bin:$PATH

#############################################################
# thx to omarchy
if command -v eza &> /dev/null; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi

if command -v zoxide &> /dev/null; then
  alias cd="z"
fi

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
#############################################################

alias cat='batcat'
# Git
alias g='git'
alias gcm='git commit -m'

alias update='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'

alias lz='lazygit'

alias cnp='rm -rf node_modules'

alias xstart='sudo /opt/lampp/lampp start'
alias xstop='sudo /opt/lampp/lampp stop'
alias xstatus='/opt/lampp/lampp status'

# Xampp path
export PATH=/opt/lampp/bin:$PATH