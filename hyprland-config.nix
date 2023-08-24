# hyprland-config.nix
{ config, pkgs, ... }: {
  wayland.windowManager.hyprland.extraConfig = ''
    # Monitor Configuration
    monitor=,highres,auto,1

    # Environment Variables
    env = XCURSOR_SIZE,24

    # Executions on Startup
    exec-once = waybar                   # Launch Waybar
    exec-once = ~/.local/bin/set-dark-theme.sh # Change GTK to dark theme
    exec-once = ~/.local/bin/lid-close.sh      # Execute lid close script
    exec-once = rm -f $XDG_RUNTIME_DIR/wob.sock && mkfifo $XDG_RUNTIME_DIR/wob.sock && tail -f $XDG_RUNTIME_DIR/wob.sock | wob # Initialise wob
    exec-once = blueman-applet           # Launch blueman
    exec-once = hyprpaper                # Start hyprpaper
    exec-once = systemctl --user import-environment # Ensure environment variables for user systemd units
    exec-once = mako                     # Launch mako


    # Input Configuration
    input {
        kb_layout = us                  # Keyboard layout
        follow_mouse = 0                # Follow mouse setting
        touchpad {
            natural_scroll = false      # Touchpad natural scroll
            clickfinger_behavior = 1    # Click finger behavior
        }
    }

    # General Configuration
    general {
        gaps_in = 5                     # Inner gaps
        gaps_out = 10                   # Outer gaps
        border_size = 2                 # Border size
        col.active_border = rgba(5289E2ee) rgba(6897BBee) 45deg # Active border color
        col.inactive_border = rgba(595959aa) # Inactive border color
        layout = hy3                    # Layout type
    }

    # Decoration Configuration
    decoration {
        rounding = 10                   # Rounding factor
        blur {
            enabled = true              # Enable blur
            size = 3                    # Blur size
            passes = 1                  # Blur passes
        }
        drop_shadow = true              # Enable drop shadow
        shadow_range = 4                # Shadow range
        shadow_render_power = 3         # Shadow render power
        col.shadow = rgba(1a1a1aee)     # Shadow color
    }
    
    # Animations Configuration
    animations {
        enabled = true
        bezier = myBezier, 0.05, 0.9, 0.1, 1.05 # Bezier curve settings
        animation = windows, 1, 7, myBezier    # Windows animation
        animation = windowsOut, 1, 7, default, popin 80% # Windows out animation
        animation = border, 1, 10, default          # Border animation
        animation = borderangle, 1, 8, default      # Border angle animation
        animation = fade, 1, 7, default              # Fade animation
        animation = workspaces, 1, 6, default       # Workspaces animation
    }

    # Master Configuration
    master {
        new_is_master = true                # Set new window as master
    }

    # Gestures Configuration
    gestures {
        workspace_swipe = false             # Workspace swipe gesture
    }

    # Device Configuration
    device:epic-mouse-v1 {
        sensitivity = -0.5                 # Sensitivity setting
    }

    # Main Modification Key
    $mainMod = SUPER
    
    # System Control Bindings
    bind = $mainMod_SHIFT, C, exec, hyprctl reload # Reload system config
    bind = $mainMod_SHIFT, Q, killactive           # Kill active window
    bind = $mainMod, ESCAPE, exec, swaylock --clock --screenshots --effect-pixelate 5 # Lock screen
    bind = $mainMod, BACKSPACE, hy3:makegroup, opposite, ephemeral # Toggle split
    bind = $mainMod_SHIFT, E, exit                 # Exit system

    # Application Bindings
    bind = $mainMod, RETURN, exec, alacritty       # Open terminal
    bind = $mainMod, SPACE, exec, rofi -show drun  # Launch rofi
    bind = $mainMod, S, exec, pavucontrol          # Open sound control
    bind = $mainMod, W, exec, alacritty -e sh -c 'sleep 0.1; nmtui' # Open network manager
    bind = $mainMod, D, exec, wdisplays            # Display settings
    bind = $mainMod, B, exec, blueman-manager      # Bluetooth manager
    
    # Audio Control Bindings
    bind = , XF86AudioRaiseVolume, exec, amixer sset Master unmute; exec amixer sset Master 5%+ | sed -En 's/.*\[([0-9]+)%\].*/\1/p' | head -1 > $XDG_RUNTIME_DIR/wob.sock
    bind = , XF86AudioLowerVolume, exec, amixer sset Master unmute; exec amixer sset Master 5%- | sed -En 's/.*\[([0-9]+)%\].*/\1/p' | head -1 > $XDG_RUNTIME_DIR/wob.sock
    bind = , XF86AudioMute, exec, amixer sset Master toggle | sed -En '/\[on\]/ s/.*\[([0-9]+)%\].*/\1/ p; /\[off\]/ s/.*/0/p' | head -1 > $XDG_RUNTIME_DIR/wob.sock

    # Brightness Control Bindings
    bind = , XF86MonBrightnessUp, exec, brightnessctl set +10%
    bind = , XF86MonBrightnessDown, exec, brightnessctl set 10%- -n 1%

    # Screenshot Binding
    bind = $mainMod, P, exec, grim -g "$(slurp)" - | swappy -f -

    # Move focus with mainMod + arrow keys
    bind = $mainMod, left, hy3:movefocus, l
    bind = $mainMod, right, hy3:movefocus, r
    bind = $mainMod, up, hy3:movefocus, u
    bind = $mainMod, down, hy3:movefocus, d

    # Switch workspaces with mainMod + [0-9]
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10
  '';
}

