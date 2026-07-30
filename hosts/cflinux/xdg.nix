{ config, lib, pkgs, ... }:
{
  xdg = {
    configHome = "${config.home.homeDirectory}/.config";
    cacheHome = "${config.home.homeDirectory}/.cache";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";

    # Some config files we need
    configFile = {
      "tmux/tmux.conf".source = ../../dotfiles/tmux/tmux.conf;
      "waybar".source = ../../dotfiles/waybar;
      "systemd/user/xdg-desktop-portal-hyprland.service".source =
        "${pkgs.xdg-desktop-portal-hyprland}/share/systemd/user/xdg-desktop-portal-hyprland.service";
      "wireplumber/main.lua.d/51-sof-sdw-fix.lua".text = ''
        rule = {
          matches = {
            {
              { "node.name", "matches", "alsa_input.*sof_sdw*" },
            },
          },
          apply_properties = {
            ["api.alsa.headroom"] = 2048,
            ["api.alsa.period-size"] = 2048,
            ["api.alsa.disable-mmap"] = true,
            ["session.suspend-timeout-seconds"] = 0,
          },
        }

        table.insert(alsa_monitor.rules, rule)
      '';
    };

    # Enable screensharing
    portal = {
      enable = lib.mkForce true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = [ "hyprland" "gtk" ];
        };
        hyprland = {
          default = [ "hyprland" "gtk" ];
        };
      };
    };
  };
}
