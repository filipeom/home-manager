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
    };
  };
}
