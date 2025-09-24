{ lib, pkgs, config, ... }:
{
 home = {
    packages = with pkgs; [
      cowsay
      git
      home-manager
      neovim
      opam
      oh-my-zsh
    ];

    username = "filipe";
    homeDirectory = "/home/${config.home.username}";

    stateVersion = "25.05";
  };

  # XDG
  xdg = import ./xdg.nix { inherit config pkgs lib; };

  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = ["Liberation Mono"];
    defaultFonts.sansSerif = ["Liberation Sans"];
    defaultFonts.serif = ["Liberation Serif"];
  };

  # programs
  programs = {
    git = import ./programs/git.nix { inherit config pkgs lib; };
    zsh = import ./programs/zsh.nix { inherit config pkgs lib; };
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.local/share/cargo/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    NODE_REPL_HISTORY = "${config.xdg.dataHome}/node_repl_history";
    OPAMROOT = "${config.xdg.dataHome}/opam";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    XINITRC = "${config.xdg.configHome}/X11/xinitrc";
  };
}
