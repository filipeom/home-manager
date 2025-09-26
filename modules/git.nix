{ lib, pkgs, config, ... }:
{
  enable = true;
  userName = "Filipe Marques";
  userEmail = "filipe.s.marques@tecnico.ulisboa.pt";
  ignores = [
    ".files"
    ".direnv/"
    ".envrc"
  ];
  extraConfig = {
    credential.helper = "store";
  };
}
