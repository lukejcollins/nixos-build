# This script generates a Nix expression with file paths from the dotfiles directory
# and then triggers rebuilds for NixOS and home-manager.

# Generate the Nix expression:
# 1. Start with an opening brace
# 2. Find all files in the 'dotfiles' directory
# 3. Strip the 'dotfiles/' prefix from each line
# 4. Use awk to format each line into a Nix attribute set entry
# 5. End with a closing brace
{
    echo "{"

    # Chain together find, sed, and awk to transform the file list
    find dotfiles -type f | \
    sed 's|^dotfiles/||' | \
    awk '{print "  \"" $0 "\".source = ./dotfiles/" $0 ";"}'

    echo "}"
} > generated-files.nix

# Git add the generated-files.nix file temporarily
git add -f "$(pwd)/generated-files.nix"
git add -f "$(pwd)/hardware-configuration.nix"

# Rebuild NixOS with the current directory as a flake target named 'mySystem'
sudo nixos-rebuild switch --flake "$(pwd)#mySystem"

# Rebuild home-manager with the current directory as a flake target named 'myUser'
# and enabling extra experimental features.
home-manager switch --flake "$(pwd)#myUser" --extra-experimental-features nix-command --extra-experimental-features flakes

# Cleanup the generated-files.nix file
git rm -f "$(pwd)/generated-files.nix"
git rm -f "$(pwd)/hardware-configuration.nix" --cached