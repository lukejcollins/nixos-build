{ config, pkgs, inputs, ... }:

let
  # Import user-specific configuration
  userConfig = import ./user-config.nix;

  rosePineDawnEmacs = pkgs.stdenv.mkDerivation rec {
    pname = "rose-pine-dawn-emacs";
    version = "2023-10-31"; # Or any other version/date indication you find suitable

    src = pkgs.fetchFromGitHub {
      owner = "thongpv87";
      repo = "rose-pine-emacs";
      rev = "master"; # Or a specific commit hash
      sha256 = "sha256-8xFnwynJtIHP2ZEMZswVyeKzG+tE8BffKaZnf46eLm8="; # This is a placeholder, replace with the actual hash
    };

    buildInputs = [ pkgs.emacs pkgs.emacsPackages.autothemer ];

    buildPhase = ''
      emacs --batch -f batch-byte-compile rose-pine-dawn-theme.el
    '';

    installPhase = ''
      mkdir -p $out/share/emacs/site-lisp/elpa/rose-pine-dawn-${version}
      cp *.el *.elc $out/share/emacs/site-lisp/elpa/rose-pine-dawn-${version}
    '';

    meta = {
      description = "Rose Pine Dawn theme for Emacs";
      license = pkgs.lib.licenses.mit; # Adjust if necessary
    };
  };
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
    wl-clipboard unzip statix nixpkgs-fmt neofetch rofi-wayland libnotify waybar htop postgresql
    insomnia docker-compose tailscale
    (emacsWithPackagesFromUsePackage {
      config = ./emacs/init.el;
      defaultInitFile = true;
      alwaysEnsure = true;
      alwaysTangle = true;
      package = pkgs.emacs-pgtk;
      extraEmacsPackages = epkgs: [
        epkgs.use-package epkgs.terraform-mode epkgs.flycheck epkgs.flycheck-inline
        epkgs.dockerfile-mode epkgs.nix-mode epkgs.blacken epkgs.treemacs
        epkgs.treemacs-all-the-icons epkgs.modus-themes epkgs.helm epkgs.vterm
        epkgs.markdown-mode epkgs.grip-mode epkgs.dash epkgs.s epkgs.editorconfig
        epkgs.autothemer rosePineDawnEmacs epkgs.ivy epkgs.counsel
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
      url = "https://github.com/nix-community/emacs-overlay/archive/d194712b55853051456bc47f39facc39d03cbc40.tar.gz";
      sha256 = "sha256:08akyd7lvjrdl23vxnn9ql9snbn25g91pd4hn3f150m79p23lrrs";
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
    tailscale.enable = true; # Enable Tailscale
  };

  # Network and Bluetooth Configurations
  networking = {
    networkmanager.enable = true; # Enable NetworkManager for network management
    hosts = { # Hosts file configurations
      "127.0.0.1" = [
      "facebook.com" "news.google.com" "old.reddit.com" "reddit.com" "theguardian.com"
      "youtube.com" "www.facebook.com" "www.reddit.com" "www.theguardian.com"
      "www.youtube.com" "bbc.co.uk" "www.bbc.co.uk" "www.neowin.net" "neowin.net"
      ];
    };
    firewall.enable = false; # Disable the firewall
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
