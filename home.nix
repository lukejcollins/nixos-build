{ pkgs, lib, config, ... }:

let
  # Import user-specific and generated file configurations
  userConfig = import ./user-config.nix;

  # Python Environment Definition
  myPythonEnv = pkgs.python3.withPackages (ps: with ps; [
    pynvim flake8 pylint black requests
  ]);

  # Tflint Installation Definition
  tflintZip = pkgs.fetchurl {
    url = "https://github.com/terraform-linters/tflint/releases/download/v0.47.0/tflint_linux_amd64.zip";
    sha256 = "sha256-CGYSO6M7HXPatyDKc6aXbl+18cWVvfGKaE1QYOygmpY=";
  };

  tflint = pkgs.stdenv.mkDerivation {
    name = "tflint";
    src = tflintZip;
    nativeBuildInputs = [ pkgs.unzip ];
    unpackPhase = "unzip $src";
    installPhase = ''
      mkdir -p $out/bin
      cp tflint $out/bin/
      chmod 755 $out/bin/tflint
    '';
  };

  # Hadolint Installation Definition
  hadolint = pkgs.stdenv.mkDerivation rec {
    pname = "hadolint";
    version = "2.12.0";
    src = pkgs.fetchurl {
      url = "https://github.com/hadolint/hadolint/releases/download/v${version}/hadolint-Linux-x86_64";
      sha256 = "sha256-1Qz2Xc4Wk2goihteg9fRNHCn99WcIl2aFwgN44MV714=";
      executable = true;
    };
    dontUnpack = true;
    installPhase = ''
      install -D $src $out/bin/hadolint
    '';
  };

  # Powerlevel10k and Copilot.vim Git Sources
  powerlevel10kSrc = builtins.fetchGit {
    url = "https://github.com/romkatv/powerlevel10k.git";
    rev = "017395a266aa15011c09e64e44a1c98ed91c478c";
  };

  copilotSrc = builtins.fetchGit {
    url = "https://github.com/github/copilot.vim";
    rev = "1358e8e45ecedc53daf971924a0541ddf6224faf";
  };

  # MesloLGS NF Font Definitions
  mesloLGSFonts = {
    Regular = builtins.fetchurl {
      url = "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf";
      name = "MesloLGS-NF-Regular.ttf";
      sha256 = "0zg5qvrdi6y2y7dwbwi4d442s78ayjmq72cy2g0dgy4pdqc4cyfr";
    };
    Bold = builtins.fetchurl {
      url = "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf";
      name = "MesloLGS-NF-Bold.ttf";
      sha256 = "00v048clvjrg2l49kf0qnfpf0vayj9c0c0pa8f1kqj67yyf1kh5n";
    };
    Italic = builtins.fetchurl {
      url = "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf";
      name = "MesloLGS-NF-Italic.ttf";
      sha256 = "1vwjsgf1d8g76sna88lwm1j878xw51cn45d9azhh8xsrwb5pndbg";
    };
    BoldItalic = builtins.fetchurl {
      url = "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf";
      name = "MesloLGS-NF-Bold-Italic.ttf";
      sha256 = "080jipmy5jpik27wcvripinmhv9jvlcbivr4ng255h6fvqd17d2n";
    };
  };

  # Vim Plug Installation Definition
  vimPlug = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/junegunn/vim-plug/0.11.0/plug.vim";
    sha256 = "0lm582jb9y571jpny8pkp72i8ms6ncrij99v0r8zc7qmqcic8k8d";
  };

in
{
  # Font Configuration
  fonts.fontconfig.enable = true;

  # Package Installation
  home.packages = with pkgs; [
    fontconfig font-awesome_5 cantarell-fonts noto-fonts
    myPythonEnv tflint hadolint
  ];

  # ZSH Configuration
  programs.zsh = {
    enable = true;
    shellAliases = { vim = "nvim"; };
  };

  # User Specific Configuration
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;

  # Dconf Settings
  dconf.settings = {
    "org/blueman/general/auto-power-on" = { value = true; };
  };

  # GTK theme and dark mode preferences
  gtk = {
    enable = true;
    theme = {
      name = "Arc-Dark";
      package = pkgs.arc-theme;
    };
  };

  # Session Variables
  home.sessionVariables = {
    PATH = with pkgs; "${myPythonEnv}/bin:$PATH";
  };

  # Home File Definitions
  home.file = {
    ".config/rofi/config.rasi".source = ./dotfiles/.config/rofi/config.rasi;
    ".config/rofi/Arc-Dark.rasi".source = ./dotfiles/.config/rofi/Arc-Dark.rasi;
    ".config/nvim/init.vim".source = ./dotfiles/.config/nvim/init.vim;
    ".config/alacritty/alacritty.yml".source = ./dotfiles/.config/alacritty/alacritty.yml;
    ".config/swappy/config".source = ./dotfiles/.config/swappy/config;
    ".config/hypr/hyprpaper.conf".source = ./dotfiles/.config/hypr/hyprpaper.conf;
    ".config/mako/config".source = ./dotfiles/.config/mako/config;
    ".zshrc".source = ./dotfiles/.zshrc;
    ".p10k.zsh".source = ./dotfiles/.p10k.zsh;
    ".local/bin/list-workspaces.sh".source = ./dotfiles/.local/bin/list-workspaces.sh;
    ".local/share/applications/shutdown.desktop".source = ./dotfiles/.local/share/applications/shutdown.desktop;
    ".local/share/applications/reboot.desktop".source = ./dotfiles/.local/share/applications/reboot.desktop;
    ".local/share/applications/logout.desktop".source = ./dotfiles/.local/share/applications/logout.desktop;
    ".local/share/nvim/site/autoload/plug.vim".source = vimPlug;
    "/powerlevel10k".source = powerlevel10kSrc;
    ".config/nvim/pack/github/start/copilot.vim".source = copilotSrc;
    ".local/share/fonts/MesloLGS-NF/MesloLGS NF Regular.ttf".source = mesloLGSFonts.Regular;
    ".local/share/fonts/MesloLGS-NF/MesloLGS NF Bold.ttf".source = mesloLGSFonts.Bold;
    ".local/share/fonts/MesloLGS-NF/MesloLGS NF Italic.ttf".source = mesloLGSFonts.Italic;
    ".local/share/fonts/MesloLGS-NF/MesloLGS NF Bold Italic.ttf".source = mesloLGSFonts.BoldItalic;
  };

  # Home Manager State Version
  home.stateVersion = "23.05";
}
