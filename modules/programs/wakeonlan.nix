{ config, lib, pkgs, ... }:

let
  cfg = config.programs.wakeonlan;

  mkScript = name: mac: pkgs.writeShellApplication {
    inherit name;

    runtimeInputs = with pkgs; [
      wakeonlan
    ];

    text = ''
      wakeonlan ${mac}
    '';
  };
in
{
  options.programs.wakeonlan = {
    enable = lib.mkEnableOption "the wake-on-lan scripts";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (mkScript "wake-vessel-01" "50:eb:f6:7b:cc:af")
      (mkScript "wake-vessel-02" "50:3e:aa:0c:8e:3e")
    ];
  };
}
