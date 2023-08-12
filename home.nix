{ pkgs, lib, config, ... }:

let
  # Import user-specific configuration
  userConfig = import ./user-config.nix;

  # Import generated file definitions
  generatedFiles = import ./generated-files.nix;

  # Define a Python environment with the specified packages
  myPythonEnv = pkgs.python3.withPackages (ps: with ps; [
    pynvim
    flake8
    pylint
    black
  ]);

  # Enable powerlevel10k
  powerlevel10kSrc = builtins.fetchGit {
    url = "https://github.com/romkatv/powerlevel10k.git";
    rev = "017395a266aa15011c09e64e44a1c98ed91c478c";
  };

in {
  # Enable fontconfig for font management
  fonts.fontconfig.enable = true;

  # Specify packages to be installed for the user
  home.packages = with pkgs; [
    fontconfig
    font-awesome_5
    cantarell-fonts
    noto-fonts
    myPythonEnv
  ];

  # ZSH shell configuration
  programs.zsh = {
    enable = true;  # Enable ZSH as the shell

    # Set aliases for ZSH shell
    shellAliases = {
      vim = "nvim";  # Use 'nvim' when 'vim' is called
    };
  };

  # Set user-specific details from the imported configuration
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;

  # Dconf modifications
  dconf.settings = {
    "org/blueman/general/auto-power-on" = { value = true; };
  };

  # Adjust user's PATH to include the Python environment binaries
  home.sessionVariables = {
    PATH = with pkgs; "${myPythonEnv}/bin:$PATH";
  };

  # Include home file definitions
  home.file = {
    ".config/rofi/config.rasi".source = ./dotfiles/.config/rofi/config.rasi;
    ".config/rofi/Arc-Dark.rasi".source = ./dotfiles/.config/rofi/Arc-Dark.rasi;
    ".config/nvim/init.vim".source = ./dotfiles/.config/nvim/init.vim;
    ".config/waybar/style.css".source = ./dotfiles/.config/waybar/style.css;
    ".config/waybar/config".source = ./dotfiles/.config/waybar/config;
    ".config/sway/config".source = ./dotfiles/.config/sway/config;
    ".config/alacritty/alacritty.yml".source = ./dotfiles/.config/alacritty/alacritty.yml;
    ".config/swappy/config".source = ./dotfiles/.config/swappy/config;
    ".zshrc".source = ./dotfiles/.zshrc;
    ".p10k.zsh".source = ./dotfiles/.p10k.zsh;
    ".local/bin/sway_split_direction.sh".source = ./dotfiles/.local/bin/sway_split_direction.sh;
    ".local/bin/set-dark-theme.sh".source = ./dotfiles/.local/bin/set-dark-theme.sh;
    ".local/share/applications/shutdown.desktop".source = ./dotfiles/.local/share/applications/shutdown.desktop;
    ".local/share/applications/reboot.desktop".source = ./dotfiles/.local/share/applications/reboot.desktop;
    ".local/share/applications/logout.desktop".source = ./dotfiles/.local/share/applications/logout.desktop;
    ".local/share/flatpak/overrides/global".source = ./dotfiles/.local/share/flatpak/overrides/global;
    "/powerlevel10k".source = powerlevel10kSrc;
  };

  # Specify the state version for home-manager
  home.stateVersion = "22.05";
}
