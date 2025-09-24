{ lib, pkgs, config, ... }:
{
  enable = true;
  configHome = "${config.home.homeDirectory}/.config";
  cacheHome = "${config.home.homeDirectory}/.cache";
  dataHome = "${config.home.homeDirectory}/.local/share";
  stateHome = "${config.home.homeDirectory}/.local/state";

  userDirs = {
    enable = true;
    desktop = "${config.home.homeDirectory}/resources";
    documents = "${config.home.homeDirectory}/resources";
    download = "${config.home.homeDirectory}/downloads";
    music = "${config.home.homeDirectory}/areas/music";
    pictures = "${config.home.homeDirectory}/resources/photos";
    publicShare = "${config.home.homeDirectory}/";
    templates = "${config.home.homeDirectory}/resources/templates";
    videos = "${config.home.homeDirectory}/";
  };

  # Some config files we need
  configFile = {
    "kitty/kitty.conf".source = ./config/kitty/kitty.conf;
    "kitty/dayfox.conf".source = ./config/kitty/dayfox.conf;
  };
}
