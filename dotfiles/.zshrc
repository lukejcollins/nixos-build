# =====================
# Initial Configuration
# =====================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =================
# Theme Configuration
# =================

# Set name of the theme to load.
ZSH_THEME="powerlevel10k/powerlevel10k"
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# =================
# Plugin Configuration
# =================

# Plugins
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git)

# =================
# Environment Configuration
# =================

# GTK theme
export GTK_THEME=Adwaita:dark

# ===============
# Aliases
# ===============

# Alias nvim to vim
alias vim='nvim'

# ===============
# Miscellaneous Configurations
# ===============

# Auto-launch Sway
if [ "$(tty)" = "/dev/tty1" ]; then
    exec sway
fi
