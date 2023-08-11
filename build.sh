{
    echo "{";
    find dotfiles -type f | \
    sed 's|^dotfiles/||' | \
    awk '{print "  \"" $0 "\".source = ./dotfiles/" $0 ";"}';
    echo "}";
} > generated-files.nix
sudo nixos-rebuild switch --flake "$(pwd)#mySystem"
home-manager switch --flake "$(pwd)#myUser" --extra-experimental-features nix-command --extra-experimental-features flakes
