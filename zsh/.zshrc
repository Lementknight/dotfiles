# ============================================================================
# Powerlevel10k Instant Prompt
# ============================================================================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# ============================================================================
# Environment Variables & PATH
# ============================================================================
export PATH="$HOME/.local/bin/claude:$PATH"
export PATH="/opt/other/:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$PATH:/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin"
export PATH="$HOME/.emacs.d/bin/:$PATH"
export PATH="$HOME/.local/bin/cask:$PATH"
export PATH="/opt/homebrew/opt/postgresql@18/bin:$PATH"
export PATH="$HOME/.cargo/env:$PATH"

# History settings
unset HISTFILE SAVEHIST

# ============================================================================
# Zi Plugin Manager Setup
# ============================================================================
typeset -A ZI
ZI[BIN_DIR]="${HOME}/.zi/bin"

# Install Zi if not present
if [[ ! -f $HOME/.zi/bin/zi.zsh ]]; then
  print -P "%F{33}▓▒░ %F{160}Installing (%F{33}z-shell/zi%F{160})…%f"
  command mkdir -p "$HOME/.zi" && command chmod go-rwX "$HOME/.zi"
  command git clone -q --depth=1 --branch "main" https://github.com/z-shell/zi "$HOME/.zi/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "${ZI[BIN_DIR]}/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

# ============================================================================
# Powerlevel10k Theme
# ============================================================================
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
zi ice depth=1
zi light romkatv/powerlevel10k

# ============================================================================
# Zi Plugins
# ============================================================================
# Load meta-plugins and annexes
zi light-mode for \
  z-shell/z-a-meta-plugins \
  @annexes @zunit

# Essential plugins
zi light zsh-users/zsh-autosuggestions
zi light zsh-users/zsh-syntax-highlighting
zi light zsh-users/zsh-completions

# Navigation tools
zi light z-shell/zsh-navigation-tools

zi snippet OMZP::git
zi snippet OMZP::brew
zi snippet OMZP::colored-man-pages
zi snippet OMZP::colorize
zi snippet OMZP::zsh-interactive-cd
zi snippet OMZP::themes

# ============================================================================
# Utilities
# ============================================================================
# Clean up missing completion files before running compinit
if [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
  for file in /opt/homebrew/share/zsh/site-functions/_orb{,ctl}; do
    [[ -f "$file" ]] || rm -f "$file" 2>/dev/null
  done
fi

autoload -Uz compinit

compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

autoload -U colors && colors
zicompinit

# ============================================================================
# Custom Configuration
# ============================================================================
# Load aliases
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh




# ============================================================================
# Custom Functions
# ============================================================================

function mager() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/magefiles" ]]; then
      MAGE_CWD="$PWD" mage -d "$dir/magefiles" "$@"
      return
    fi
    dir="$(dirname "$dir")"
  done
  echo "No magefiles/ directory found in any parent directory"
  return 1
}

# bun completions
[ -s "/Users/caaguirr/.bun/_bun" ] && source "/Users/caaguirr/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH=/opt/homebrew/opt/icu4c@77/bin:$PATH
export PATH=/opt/homebrew/opt/icu4c@77/sbin:$PATH
