# hyprland-config.nix
{ config, pkgs, ... }: {
  wayland.windowManager.hyprland.extraConfig = ''
    # Configure monitor
    monitor=,highres,auto,1

    # Launch Waybar
    exec-once = waybar

    # Change GTK to dark theme
    exec-once = ~/.local/bin/set-dark-theme.sh

    # Execute lid close script
    exec-once = ~/.local/bin/lid-close.sh

    # Initialise wob
    exec-once = rm -f $XDG_RUNTIME_DIR/wob.sock && mkfifo $XDG_RUNTIME_DIR/wob.sock && tail -f $XDG_RUNTIME_DIR/wob.sock | wob

    # Launch blueman
    exec-once = blueman-applet

    # Start hyprpaper
    exec-once = hyprpaper 

    # Ensure that the environment variables are correctly set for the user systemd units
    exec-once = systemctl --user import-environment
    
    # Cursor size
    env = XCURSOR_SIZE,24

    # Input config
    input {
        kb_layout = us

        follow_mouse = 0

        touchpad {
            natural_scroll = false
            clickfinger_behavior = 1
        }

    }

    general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgba(5289E2ee) rgba(6897BBee) 45deg
        col.inactive_border = rgba(595959aa)

        layout = hy3
    }

    decoration {
        rounding = 10

        blur {
            enabled = true
            size = 3
            passes = 1
        }

        drop_shadow = true
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)
    }

    animations {
        enabled = true

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
    }

    master {
        new_is_master = true
    }

    gestures {
        workspace_swipe = false
    }

    device:epic-mouse-v1 {
        sensitivity = -0.5
    }

    $mainMod = SUPER

    bind = $mainMod_SHIFT, C, exec, hyprctl reload

    bind = $mainMod, RETURN, exec, alacritty
    bind = $mainMod_SHIFT, Q, killactive,
    bind = $mainMod_SHIFT, E, exit,
    bind = $mainMod, E, exec, dolphin
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, SPACE, exec, rofi -show drun
    bind = $mainMod, S, exec, pavucontrol
    bind = $mainMod, W, exec, alacritty -e sh -c 'sleep 0.1; nmtui'
    bind = $mainMod, D, exec, wdisplays
    bind = $mainMod, B, exec, blueman-manager
    bind = , XF86AudioRaiseVolume, exec, amixer sset Master unmute; exec amixer sset Master 5%+ | sed -En 's/.*\[([0-9]+)%\].*/\1/p' | head -1 > $XDG_RUNTIME_DIR/wob.sock
    bind = , XF86AudioLowerVolume, exec, amixer sset Master unmute; exec amixer sset Master 5%- | sed -En 's/.*\[([0-9]+)%\].*/\1/p' | head -1 > $XDG_RUNTIME_DIR/wob.sock
    bind = , XF86AudioMute, exec, amixer sset Master toggle | sed -En '/\[on\]/ s/.*\[([0-9]+)%\].*/\1/ p; /\[off\]/ s/.*/0/p' | head -1 > $XDG_RUNTIME_DIR/wob.sock
    bind = , XF86MonBrightnessUp, exec, brightnessctl set +10%
    bind = , XF86MonBrightnessDown, exec, brightnessctl set 10%- -n 1%
    bind = $mainMod, ESCAPE, exec, swaylock --clock --screenshots --effect-pixelate 5
    bind = $mainMod, P, exec, grim -g "$(slurp)" - | swappy -f -

    # Move focus with mainMod + arrow keys
    bind = $mainMod, left, hy3:movefocus, l
    bind = $mainMod, right, hy3:movefocus, r
    bind = $mainMod, up, hy3:movefocus, u
    bind = $mainMod, down, hy3:movefocus, d

    # Toggle split
    bind = $mainMod, BACKSPACE, hy3:makegroup, opposite, ephemeral

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

    # Scroll through existing workspaces with mainMod + scroll
    bind = $mainMod, mouse_down, workspace, e+1
    bind = $mainMod, mouse_up, workspace, e-1

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = $mainMod, mouse:272, hy3:movewindow
    bindm = $mainMod, mouse:273, resizewindow
  '';
}

