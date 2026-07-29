{ config, pkgs, lib, ... }:
let
  nixGLWrap = pkg: binaryName:
    let
      wrapped = pkgs.symlinkJoin {
        name = "${pkg.name}-nixgl";
        paths = [ pkg ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          rm $out/bin/${binaryName}
          makeWrapper ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel $out/bin/${binaryName} \
            --add-flags "${pkg}/bin/${binaryName}"
        '';
      };
    in
      wrapped // {
        override = args: nixGLWrap (pkg.override args) binaryName;
      };
in
{
  home.username = "filipe";
  home.homeDirectory = "/home/filipe";
  home.stateVersion = "26.05";

  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    git
    tmux
    direnv
    opam
    rustup
    nodejs_26
    opencode

    # Hyprland utilities
    waybar
    brightnessctl
    hypridle
    hyprlock
    hyprshot
    wofi
    nerd-fonts.jetbrains-mono
    mako
  ];

  imports = [
    ../../modules/programs/git.nix
    ../../modules/programs/kitty.nix
    ../../modules/programs/zsh.nix
    ../../modules/programs/neovim.nix
    ../../modules/programs/tmux-sessionizer.nix
    # Services
    ../../modules/services/hyprsunset.nix
    ../../modules/services/hyprpaper.nix
    ./xdg.nix
  ];

  xdg.enable = true;

  # programs
  programs.git = {
    enable = true;
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519";
      signByDefault = true;
    };
    settings = {
      user.name = lib.mkForce "Filipe Marques";
      user.email = lib.mkForce "fmarques@cloudflare.com";
    };
  };

  programs.zsh = {
    enable = true;
    initContent = ''
      bindkey -s ^f "tmux-sessionizer\n"

      tmpd() { cd $(mktemp -d) }
     '';
    shellAliases.oc = "clear && opencode auth login https://opencode.cloudflare.dev && opencode mcp auth cf-portal && opencode";
  };

  programs.tmux-sessionizer = {
    enable = true;
    searchDirs = [
      "~/Projects"
      "~/Documents"
    ];
  };

  programs.neovim.enable = true;
  programs.waybar.enable = true;

  programs.kitty = {
    enable = true;
    package = nixGLWrap pkgs.kitty "kitty";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    package = nixGLWrap pkgs.hyprland "Hyprland";
    settings = {
      monitor = [
        "eDP-1,highres@highrr,0x0,1.25"
        ",highres@highrr,auto,auto"
      ];

      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --show drun";

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
      ];

      exec-once = [
        "systemctl --user start hypridle hyprsunset hyprpaper mako"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;

        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        resize_on_border = false;
        allow_tearing = false;
        layout = "master";
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;

        active_opacity = 1.0;
        inactive_opacity = 1.0;
      };

      master = {
        new_status = "master";
        new_on_top = true;
        orientation = "left";
        mfact = 0.55;
      };

      misc = {
        force_default_wallpaper = 1;
        disable_hyprland_logo = true;
        allow_session_lock_restore = true;
      };

      input = {
        kb_layout = "us,us";
        kb_variant = ",intl";
        kb_options = "grp:alt_shift_toggle,ctrl:nocaps";

        follow_mouse = 1;

        repeat_rate = 70;
        repeat_delay = 290;
      };

      bind = [
        "$mod, P, exec, $menu"
        "$mod SHIFT, RETURN, exec, $terminal"
        "$mod SHIFT, C, killactive,"
        "$mod SHIFT, Q, exit,"
        "$mod, RETURN, layoutmsg, swapwithmaster"
        "$mod, E, exec, $fileManager"
        "$mod, F, togglefloating,"
        "$mod SHIFT, F, fullscreen,"
        "$mod, X, exec, hyprlock"

        # Move focus with mainMod + hjkl
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"

        # Move window with mainMod + SHIFT + hjkl
        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, j, movewindow, d"
        "$mod SHIFT, k, movewindow, u"

        # Resize with mainMod + ALT + hjkl
        "ALT $mod, h, resizeactive, -40 0"
        "ALT $mod, l, resizeactive, 40 0"
        "ALT $mod, j, resizeactive, 0 40"
        "ALT $mod, k, resizeactive, 0 -40"

        "$mode, comma, focusmonitor, +1"
        "$mode, period, focusmonitor, -1"

        # Switch workspaces with mainMod + [0-9]
        "$mod, 1, focusworkspaceoncurrentmonitor, 1"
        "$mod, 2, focusworkspaceoncurrentmonitor, 2"
        "$mod, 3, focusworkspaceoncurrentmonitor, 3"
        "$mod, 4, focusworkspaceoncurrentmonitor, 4"
        "$mod, 5, focusworkspaceoncurrentmonitor, 5"
        "$mod, 6, focusworkspaceoncurrentmonitor, 6"
        "$mod, 7, focusworkspaceoncurrentmonitor, 7"
        "$mod, 8, focusworkspaceoncurrentmonitor, 8"
        "$mod, 9, focusworkspaceoncurrentmonitor, 9"
        "$mod, 0, focusworkspaceoncurrentmonitor, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        # Screenshots
        ", PRINT, exec, hyprshot -m output"
        "$mod, PRINT, exec, hyprshot -m region"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  systemd.user = {
    services = {
      waybar = import ../../modules/services/waybar.nix { inherit config pkgs lib; };
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        before_sleep_cmd = "loginctl lock-session";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 900;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  services.hyprpaper.enable = true;
  services.hyprsunset.enable = true;

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      border-radius = 5;
      background-color = "#282a36ee";
      border-color = "#bd93f9";
    };
  };

  programs.opencode = {
    enable = true;
    settings = {
      model = "google/gemini-3.6-flash";
      autoupdate = false;
      permission = "allow";
    };
  };

  programs.home-manager.enable = true;

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.nix-profile/bin"
    "$HOME/go/bin"
  ];
}
