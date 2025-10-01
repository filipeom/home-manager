{ lib, pkgs, config, ... }:
{
 home = {
    packages = with pkgs; [
      home-manager
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
    git = import ../../modules/git.nix { inherit config pkgs lib; };
    zsh = import ../../modules/zsh.nix { inherit config pkgs lib; };
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
    XINITRC = "${config.xdg.configHome}/X11/xinitrc";
    # Rust
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    RUSTUP_HOME="${config.xdg.dataHome}/rustup";
  };
}
