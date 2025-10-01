{ lib, pkgs, config, ... }:
{
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

    eval $(opam env)
    '';

}
