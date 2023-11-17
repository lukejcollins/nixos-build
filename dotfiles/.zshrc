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

# ===============
# Aliases
# ===============

# Flake build alias
alias flake-build='sudo nixos-rebuild switch --flake "$(pwd)#mySystem" && home-manager switch --flake "$(pwd)#myUser" --extra-experimental-features nix-command --extra-experimental-features flakes'

# Flake update
alias flake-update='sudo nix flake update --extra-experimental-features nix-command --extra-experimental-features flakes && flake-build'

# NixOS clean
alias nixos-clean='sudo nix-env --delete-generations old -p /nix/var/nix/profiles/system && sudo nix-collect-garbage -d && flake-build'

# Connect to Forticlient
alias forticlient='sudo openfortivpn -c /home/lukecollins/.config/vpn --username=ovoenergy/luke.collins --pppd-accept-remote'

# ===============
# Miscellaneous Configurations
# ===============

# Auto-launch Hyprland
if [ "$(tty)" = "/dev/tty1" ]; then
    exec nixGLIntel Hyprland
fi
