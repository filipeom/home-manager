{ lib, pkgs, config, ... }:
{
  enable = true;
  extraConfig = builtins.readFile ../config/tmux/tmux.conf;
}
