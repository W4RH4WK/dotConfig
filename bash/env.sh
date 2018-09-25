# ------------------------------------------------------------ PATH
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

# Snap
#export PATH="/snap/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Ruby
export PATH="$(ruby -rrubygems -e 'puts Gem.user_dir')/bin:$PATH"

# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Node
export NPM_PACKAGES="$HOME/.npm-packages"
export PATH="$NPM_PACKAGES/bin:$PATH"

# Local
export PATH="$HOME/.local/bin:$PATH"

# ------------------------------------------------------------ TOOLS
export EDITOR="/usr/bin/nvim"
export PAGER="/usr/bin/nvim -R -c 'call Paging()' -"
export MANPAGER="/usr/bin/nvim -R -c 'set filetype=man' -"

# ------------------------------------------------------------ WINE
export WINEARCH="win32"
export WINEPREFIX="$HOME/.wine32"
