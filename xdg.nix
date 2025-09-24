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
    "tmux/tmux.conf".source = ./config/tmux/tmux.conf;
    "kitty/kitty.conf".source = ./config/kitty/kitty.conf;
    "kitty/dayfox.conf".source = ./config/kitty/dayfox.conf;
    # TODO: Find a better way to do this
    "nvim/init.lua".source = ./config/nvim/init.lua;
    "nvim/lua/filipeom/init.lua".source = ./config/nvim/lua/filipeom/init.lua;
    "nvim/lua/filipeom/cmd.lua".source = ./config/nvim/lua/filipeom/cmd.lua;
    "nvim/lua/filipeom/plugins.lua".source = ./config/nvim/lua/filipeom/plugins.lua;
    "nvim/lua/filipeom/remap.lua".source = ./config/nvim/lua/filipeom/remap.lua;
    "nvim/lua/filipeom/set.lua".source = ./config/nvim/lua/filipeom/set.lua;
    "nvim/after/plugin/barbar.lua".source = ./config/nvim/after/plugin/barbar.lua;
    "nvim/after/plugin/cmp.lua".source = ./config/nvim/after/plugin/cmp.lua;
    "nvim/after/plugin/colors.lua".source = ./config/nvim/after/plugin/colors.lua;
    "nvim/after/plugin/fugitive.lua".source = ./config/nvim/after/plugin/fugitive.lua;
    "nvim/after/plugin/lsp.lua".source = ./config/nvim/after/plugin/lsp.lua;
    "nvim/after/plugin/telescope.lua".source = ./config/nvim/after/plugin/telescope.lua;
    "nvim/after/plugin/treesitter.lua".source = ./config/nvim/after/plugin/treesitter.lua;
    "nvim/after/plugin/vimtex.lua".source = ./config/nvim/after/plugin/vimtex.lua;
  };
}
