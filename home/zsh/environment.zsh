# Set environment variables.
export EDITOR='vim'
export VISUAL='vim'
export DIFFPROG='vim'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Ensure 256 colors in the terminals.
[[ "$TERM" == "xterm" ]] && export TERM=xterm-256-color
[[ "$TERM" == "rxvt" ]] && export TERM=rxvt-unicode-256-color

# Add Ruby gems into path.
if which ruby >/dev/null && which gem >/dev/null; then
  PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

# Source nvm
# - Depends on the fact that I've installed nvm from the AUR.
source /usr/share/nvm/init-nvm.sh
