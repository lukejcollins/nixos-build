{
  description = "A flake for building Sway with custom configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }: {
    userConfig = import ./user-config.nix;

    homeConfigurations = {
      myUser = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ({ pkgs, lib, config, ... }: let
            # Define Python environment with required packages
            myPythonEnv = pkgs.python3.withPackages (ps: with ps; [
              pynvim
              flake8
              pylint
              black
            ]);
          in {
            fonts.fontconfig.enable = true;
            home.packages = with pkgs; [
              fontconfig font-awesome_5 cantarell-fonts noto-fonts sway waybar wob
              blueman github-cli neovim foot firefox docker zsh networkmanager
              libfido2 swappy nodejs shellcheck go light rofi dunst xfce.thunar
              swaylock-effects myPythonEnv libnotify
            ];
            home.username = self.userConfig.username;
            home.homeDirectory = self.userConfig.homeDirectory;
            home.file.".config/sway/config".source = ./dotfiles/.config/sway/config;
            home.file.".config/waybar/config".source = ./dotfiles/.config/waybar/config;
            home.file.".config/waybar/style.css".source = ./dotfiles/.config/waybar/style.css;
            home.file.".config/foot/foot.ini".source = ./dotfiles/.config/foot/foot.ini;
            home.sessionVariables = {
              WLR_NO_HARDWARE_CURSORS = "1";
              PATH = with pkgs;
                "${pkgs.sway}/bin:${pkgs.waybar}/bin:${pkgs.wob}/bin:${pkgs.blueman}/bin:${pkgs.github-cli}/bin"
              + ":${pkgs.neovim}/bin:${pkgs.foot}/bin:${pkgs.firefox}/bin:${pkgs.docker}/bin:${pkgs.zsh}/bin"
              + ":${pkgs.networkmanager}/bin:${pkgs.nodejs}/bin:${myPythonEnv}/bin:${pkgs.go}/bin:${pkgs.light}/bin"
              + ":${pkgs.rofi}/bin:${pkgs.dunst}/bin:${pkgs.xfce.thunar}/bin:${pkgs.swaylock-effects}/bin"
	      + ":${pkgs.libnotify}/bin:$PATH";
            };

            programs.bash = {
              enable = true;
              shellAliases = {
                ll = "ls -l";
                vim = "nvim";
              };
            };

            home.stateVersion = "22.05";
          })
        ];
      };
    };
  };
}
