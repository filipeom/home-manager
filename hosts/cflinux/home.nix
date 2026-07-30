{ config, pkgs, lib, ... }:
let
  nixGLWrap = pkg: binaryName:
    let
      wrapped = pkgs.symlinkJoin {
        name = "${pkg.name}-nixgl";
        paths = [ pkg ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          rm $out/bin/${binaryName}
          makeWrapper ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel $out/bin/${binaryName} \
            --add-flags "${pkg}/bin/${binaryName}"
        '';
      };
    in
      wrapped // {
        override = args: nixGLWrap (pkg.override args) binaryName;
      };
in
{
  home.username = "filipe";
  home.homeDirectory = "/home/filipe";
  home.stateVersion = "26.05";

  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    git
    tmux
    direnv
    opam
    rustup
    nodejs_26
    opencode

    nerd-fonts.jetbrains-mono
    pavucontrol
  ];

  imports = [
    ../../modules/programs/git.nix
    ../../modules/programs/kitty.nix
    ../../modules/programs/zsh.nix
    ../../modules/programs/neovim.nix
    ../../modules/programs/tmux-sessionizer.nix
    # Services
    ../../modules/services/hyprland.nix
    ./xdg.nix
  ];

  xdg.enable = true;

  # programs
  programs.git = {
    enable = true;
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519";
      signByDefault = true;
    };
    settings = {
      user.name = lib.mkForce "Filipe Marques";
      user.email = lib.mkForce "fmarques@cloudflare.com";
    };
  };

  programs.zsh = {
    enable = true;
    initContent = ''
      bindkey -s ^f "tmux-sessionizer\n"

      tmpd() { cd $(mktemp -d) }
     '';
    shellAliases.oc = "clear && opencode auth login https://opencode.cloudflare.dev && opencode mcp auth cf-portal && opencode";
  };

  programs.tmux-sessionizer = {
    enable = true;
    searchDirs = [
      "~/Projects"
      "~/Documents"
    ];
  };

  programs.neovim.enable = true;

  programs.kitty = {
    enable = true;
    package = nixGLWrap pkgs.kitty "kitty";
  };

  # Hyprland environment
  my.hyprland.enable = true;

  wayland.windowManager.hyprland = {
    package = nixGLWrap pkgs.hyprland "Hyprland";
    portalPackage = null;
    settings = {
      monitor = [
        "eDP-1,highres@highrr,0x0,1.25"
        ",highres@highrr,auto,auto"
      ];

      input = {
        kb_layout = "us,us";
        kb_variant = ",intl";
      };

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user restart xdg-desktop-portal-hyprland xdg-desktop-portal"
      ];
    };
  };

  programs.opencode = {
    enable = true;
    settings = {
      model = "google/gemini-3.6-flash";
      autoupdate = false;
      permission = "allow";
    };
  };

  programs.home-manager.enable = true;

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.nix-profile/bin"
    "$HOME/go/bin"
  ];
}
