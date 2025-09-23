{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      hello
    ];

    username = "filipe";
    homeDirectory = "/home/filipe";

    stateVersion = "25.05";
  };
}
