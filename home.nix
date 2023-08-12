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

  # Install Tflint
  tflintZip = pkgs.fetchurl {
    url = "https://github.com/terraform-linters/tflint/releases/download/v0.47.0/tflint_linux_amd64.zip";
    sha256 = "sha256-CGYSO6M7HXPatyDKc6aXbl+18cWVvfGKaE1QYOygmpY="; # You need to provide the sha256 for the downloaded zip file
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

  # Enable powerlevel10k
  powerlevel10kSrc = builtins.fetchGit {
    url = "https://github.com/romkatv/powerlevel10k.git";
    rev = "017395a266aa15011c09e64e44a1c98ed91c478c";
  };

  # Install copilot.vim
  copilotSrc = builtins.fetchGit {
    url = "https://github.com/github/copilot.vim";
    rev = "1358e8e45ecedc53daf971924a0541ddf6224faf";
  };

  # MesloLGS NF font files
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

  # Install vim-plug
  vimPlug = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/junegunn/vim-plug/0.11.0/plug.vim";
    sha256 = "0lm582jb9y571jpny8pkp72i8ms6ncrij99v0r8zc7qmqcic8k8d";
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
    tflint
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
    ".local/share/nvim/site/autoload/plug.vim".source = vimPlug;
    "/powerlevel10k".source = powerlevel10kSrc;
    ".config/nvim/pack/github/start/copilot.vim".source = copilotSrc;
    ".local/share/fonts/MesloLGS-NF/MesloLGS NF Regular.ttf".source = mesloLGSFonts.Regular;
    ".local/share/fonts/MesloLGS-NF/MesloLGS NF Bold.ttf".source = mesloLGSFonts.Bold;
    ".local/share/fonts/MesloLGS-NF/MesloLGS NF Italic.ttf".source = mesloLGSFonts.Italic;
    ".local/share/fonts/MesloLGS-NF/MesloLGS NF Bold Italic.ttf".source = mesloLGSFonts.BoldItalic;
  };

  # Specify the state version for home-manager
  home.stateVersion = "22.05";
}
