{ config, pkgs, ... }:
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
    };

# Enable screensharing
    portal = {
      enable = true;
      extraPortals = with pkgs; [
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
