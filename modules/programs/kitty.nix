{ lib, pkgs, config, ... }:
{
  programs.kitty = {
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      font_size = 14;
      force_ltr = "no";
      disable_ligatures = "never";

      box_drawing_scale = "0.001, 1, 1.5, 2";
      text_composition_strategy = "1.8 5";
      text_fg_override_threshold = 0;

      cursor_shape = "block";
      cursor_blink_interval = "0.5";
      cursor_beam_thickness = "1.5";

      scrollback_lines = 10000;
      scrollback_pager_history_size = 100;

      confirm_os_window_close = 0;
    };

    extraConfig = ''
      include ${../../dotfiles/kitty/dayfox.conf}
    '';
  };
}
