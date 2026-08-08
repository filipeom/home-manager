{ lib, pkgs, config, ... }:

let
  cfg = config.my.power-tune;

  power-tune = pkgs.writeShellApplication {
    name = "power-tune";
    runtimeInputs = with pkgs; [ brightnessctl ];
    text = ''
      if [ "$(cat /sys/class/power_supply/AC/online)" = "1" ]; then
        PL1=${toString cfg.ac.pl1}
        PL2=${toString cfg.ac.pl2}
        brightnessctl --quiet -d ${cfg.backlight} set ${toString cfg.ac.brightness}%
      else
        PL1=${toString cfg.battery.pl1}
        PL2=${toString cfg.battery.pl2}
        brightnessctl --quiet -d ${cfg.backlight} set ${toString cfg.battery.brightness}%
      fi
      echo "$PL1" > /sys/class/powercap/intel-rapl:0/constraint_0_power_limit_uw
      echo "$PL2" > /sys/class/powercap/intel-rapl:0/constraint_1_power_limit_uw
    '';
  };
in
{
  options.my.power-tune = {
    enable = lib.mkEnableOption "battery-aware power and brightness tuning";

    backlight = lib.mkOption {
      type = lib.types.str;
      default = "intel_backlight";
      description = "Backlight device name (see /sys/class/backlight).";
    };

    ac = {
      pl1 = lib.mkOption {
        type = lib.types.int;
        default = 22000000;
        description = "AC long-term power limit in microwatts.";
      };
      pl2 = lib.mkOption {
        type = lib.types.int;
        default = 30000000;
        description = "AC short-term power limit in microwatts.";
      };
      brightness = lib.mkOption {
        type = lib.types.int;
        default = 100;
        description = "Brightness percentage on AC.";
      };
    };

    battery = {
      pl1 = lib.mkOption {
        type = lib.types.int;
        default = 15000000;
        description = "Battery long-term power limit in microwatts.";
      };
      pl2 = lib.mkOption {
        type = lib.types.int;
        default = 20000000;
        description = "Battery short-term power limit in microwatts.";
      };
      brightness = lib.mkOption {
        type = lib.types.int;
        default = 50;
        description = "Brightness percentage on battery.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.power-tune = {
      description = "Tune RAPL power limits and brightness";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-udev-settle.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${power-tune}/bin/power-tune";
      };
    };

    services.udev.extraRules = ''
      ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", RUN+="${power-tune}/bin/power-tune"
    '';
  };
}
