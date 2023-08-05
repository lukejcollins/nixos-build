{
  description = "A flake for building Sway with custom configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }: {
    homeConfigurations = {
      lukecollins = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ({ pkgs, lib, ... }: {
            # Define user-specific details here
            home.username = "lukecollins";
            home.homeDirectory = "/home/lukecollins";
            home.stateVersion = "22.05";

            home.packages = with pkgs; [ sway ];

            home.file.".config/sway/config".source = ./dotfiles/.config/sway/config;

            home.sessionVariables = {
              WLR_NO_HARDWARE_CURSORS = "1";
              PATH = "${pkgs.sway}/bin:$PATH";
            };

            programs.bash = {
              enable = true;
              shellAliases = {
                ll = "ls -l";
              };
            };
          })
        ];
      };
    };
  };
}
