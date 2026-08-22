{ lib, pkgs, config, ... }:
{
  home = {
    packages = with pkgs; [
      # System config pkgs
      kitty
      nerd-fonts.jetbrains-mono

      # Social stuff
      thunderbird
      slack
      zulip
      google-chrome
      deltachat-desktop
      discord

      # Development
      git
      direnv
      docker-compose
      basedpyright
      marksman
      texlab
      vtsls
      opam
      clang
      jq
      gh

      tmux
      btop
      htop
      keepassxc
      nextcloud-client
      networkmanagerapplet

      # Office stuff
      libreoffice-fresh
      hunspell
      hunspellDicts.en_US
      hunspellDicts.pt_PT
      texliveFull
      zathura
      zotero
    ];

    username = "filipe";
    homeDirectory = "/home/${config.home.username}";

    stateVersion = "26.05";
  };

  imports = [
    ../../modules/programs/git.nix
    ../../modules/programs/zsh.nix
    ../../modules/programs/neovim.nix
    ../../modules/programs/kitty.nix
    ../../modules/programs/tmux-sessionizer.nix
    ../../modules/programs/wakeonlan.nix
    # Services
    ../../modules/services/hyprland.nix
    ./xdg.nix
    ./gtk.nix
  ];

  xdg.enable = true;

  # programs
  programs.git = {
    enable = true;
    signing = {
      format = "ssh";
      key = "${config.home.homeDirectory}/.ssh/id_helm.pub";
      signByDefault = true;
    };
    settings = {
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
    };
  };

  programs.zsh = {
    enable = true;
    initContent = ''
      bindkey -s ^f "tmux-sessionizer\n"

      eval $(opam env)

      tmpd() { cd $(mktemp -d) }
      '';
  };

  programs.neovim.enable = true;
  programs.kitty.enable = true;
  programs.wakeonlan.enable = true;

  programs.waybar.enable = true;

  programs.tmux-sessionizer = {
    enable = true;
    searchDirs = [
      "~/projects"
      "~/documents/resources/notes"
    ];
  };

  programs.opencode = {
    enable = true;
    settings = {
      autoupdate = false;
    };
  };

  # Hyprland environment
  my.hyprland.enable = true;

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1,highres@highrr,0x0,1"
      # Fallback for any unexpected extra monitors
      ",preferred,1920x0,auto"
    ];

    exec-once = [
      "nextcloud"
      "nm-applet"
    ];
  };

  # services
  services.ssh-agent.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
