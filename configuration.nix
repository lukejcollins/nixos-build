{ config, pkgs, inputs, ... }:

let
  # Import user-specific configuration
  userConfig = import ./user-config.nix;

in
{
  # General System Configurations
  system.stateVersion = "23.05"; # System version specification
  nixpkgs.config.allowUnfree = true; # Enable non-free packages
  time.timeZone = "Europe/London"; # Set timezone

  # Hardware and Boot Configurations
  imports = [ ./hardware-configuration.nix ]; # Include hardware-specific configurations
  boot = {
    loader = { 
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_6_5; # Specify the Linux kernel package version
  };
  
  # Disable all power management related services
  systemd.targets = {
    suspend = {};
    hibernate = {};
    hybrid-sleep = {};
    sleep = {};
  };

  # User Configurations
  users.users.${userConfig.username} = {
    isNormalUser = true;
    home = userConfig.homeDirectory;
    shell = pkgs.zsh; # Setting Zsh as the default shell
    extraGroups = [ "wheel" "networkmanager" ]; # Adding the user to groups
  };

  # Software and Package Configurations
  environment.systemPackages = with pkgs; [ # List of packages to be globally installed
    alacritty google-chrome wget docker wob libfido2 gh swappy swaylock-effects
    nodejs python3 python3Packages.pip shellcheck wdisplays git blueman brightnessctl hyprpaper
    home-manager pavucontrol alsa-utils grim bluez vscode gnome.gnome-boxes shfmt mako slurp 
    wl-clipboard unzip statix nixpkgs-fmt neofetch rofi-wayland libnotify waybar gotop postgresql
    insomnia docker-compose
    (emacsWithPackagesFromUsePackage {
      config = ./emacs/init.el;
      defaultInitFile = true;
      alwaysEnsure = true;
      alwaysTangle = true;
      package = pkgs.emacs-pgtk;
      extraEmacsPackages = epkgs: [
        epkgs.use-package epkgs.terraform-mode epkgs.flycheck epkgs.flycheck-inline
        epkgs.dockerfile-mode epkgs.nix-mode epkgs.blacken epkgs.treemacs
        epkgs.treemacs-all-the-icons epkgs.solarized-theme epkgs.helm epkgs.vterm
        epkgs.markdown-mode epkgs.grip-mode epkgs.dash epkgs.s epkgs.editorconfig
      ];
    })
  ];
  virtualisation.docker.enable = true; # Enable Docker
  programs.dconf.enable = true; # Enable DConf for configuration management
  programs.zsh.enable = true; # Enable ZSH for the system
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "sha256:17wrjcswbzw5fdrwk3p6m45xhkmn664kx6pn87d9mffxhm5br0i3";
    }))
  ];

  # Sound and Media Configurations
  sound.enable = true; # Enable sound support
  security.rtkit.enable = true; # Enable RTKit for low-latency audio
  services = {
    pipewire = { # Enable PipeWire for audio support
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true; # If you want to enable 32 bit application support
      };
      jack = {
        enable = true; 
      };
      pulse.enable = true; # This enables the PulseAudio compatibility modules
    };
    blueman.enable = true; # Blueman service for managing Bluetooth
    fwupd.enable = true; # Enable firmware update
  };

  # Network and Bluetooth Configurations
  networking = {
    networkmanager.enable = true; # Enable NetworkManager for network management
    hosts = { # Hosts file configurations
      "127.0.0.1" = [
      "facebook.com" "news.google.com" "old.reddit.com" "reddit.com" "theguardian.com"
      "youtube.com" "www.facebook.com" "www.reddit.com" "www.theguardian.com"
      "www.youtube.com"
      ];
    };
  };
  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluez; # Use the full Bluez package for Bluetooth support
      powerOnBoot = true; # Power on Bluetooth devices at boot
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    enableAllFirmware = true;
    opengl = {
      enable = true; # Enable OpenGL support
      driSupport = true; # Enable Direct Rendering Infrastructure support
    };
  };
  security.pam.services.swaylock = { allowNullPassword = true; }; # Enable PAM for Swaylock
}
