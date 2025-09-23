{ lib, pkgs, ... }:
let
  username = "filipe";
in
{
  home = {
    packages = with pkgs; [
      cowsay
      git
      home-manager
      opam
    ];

    username = "${username}";
    homeDirectory = "/home/${username}";

    stateVersion = "25.05";

  };

  programs.git = {
    enable = true;
    userName = "Filipe Marques";
    userEmail = "filipe.s.marques@tecnico.ulisboa.pt";
    ignores = [
      # Dotfiles
      ".files"
      # Direnv stuff
      ".direnv/"
      ".envrc"
    ];
    extraConfig = {
      credential.helper = "store";
    };
  };

}
