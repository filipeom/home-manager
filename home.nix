{ lib, pkgs, config, ... }:
{
  home = {
    packages = with pkgs; [
      cowsay
      git
      home-manager
      opam
      oh-my-zsh
    ];

    username = "filipe";
    homeDirectory = "/home/${config.home.username}";

    stateVersion = "25.05";

  };

  # XDG
  xdg = {
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
  };

  # Git
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

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history.path = "${config.xdg.dataHome}/zsh/zsh_history";
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "direnv"
      ];
      theme = "robbyrussell";
    };
    shellAliases = {
      e = "$EDITOR";
      vi = "nvim";
      vim = "nvim";
    };
    initContent = ''
      bindkey -s ^f "tmux-sessionizer\n"
    '';
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
