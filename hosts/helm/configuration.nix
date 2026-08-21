# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/services/power-tune.nix
    ];

  hardware.bluetooth.enable = true;

  # Swap for hibernation (S4)
  swapDevices = [
    { device = "/swapfile"; size = 24576; }
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Resume from swapfile for hibernation
  boot.resumeDevice = "/dev/nvme0n1p2";
  boot.kernelParams = [ "resume_offset=33781760" ];

  networking.hostName = "helm"; # Define your hostname.
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
    enable = true;
    dns = "none";
  };

  # Enable podman with docker alias
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };

  virtualisation.containers.containersConf.settings = {
    containers = {
      # Mount the /nix store as read-only natively via the container engine
      volumes = [ "/nix:/nix:ro" ];
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_PT.UTF-8";
    LC_IDENTIFICATION = "pt_PT.UTF-8";
    LC_MEASUREMENT = "pt_PT.UTF-8";
    LC_MONETARY = "pt_PT.UTF-8";
    LC_NAME = "pt_PT.UTF-8";
    LC_NUMERIC = "pt_PT.UTF-8";
    LC_PAPER = "pt_PT.UTF-8";
    LC_TELEPHONE = "pt_PT.UTF-8";
    LC_TIME = "pt_PT.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."filipe" = {
    isNormalUser = true;
    description = "Filipe Marques";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  security.pam.services.hyprlock.fprintAuth = true;

  # Annoying sudo password
  security.sudo.extraRules = [
    {
      users = [ "filipe" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    bzip2
    git
    gnutar
    gzip
    zip
    unzip
    gcc
    gnumake
    gawk
    nodejs_24
    python314
    rustup
    neovim
    wget
    curl
    pavucontrol
    pulseaudio
    inetutils
    dnsutils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.zsh.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    glib
  ];

  # Enable display manager
  services.displayManager.gdm.enable = true;

  services.cloudflare-warp.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable mDNS/Avahi for .local resolution
  services.avahi = {
    enable = true;
    nssmdns4 = true; # Allows the system to resolve other .local addresses
    openFirewall = true; # Automatically opens the necessary UDP port (5353)
    publish = {
      enable = true;
      addresses = true;
      userServices = true;
    };
  };

  # Use PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;   # allows legacy ALSA apps
    pulse.enable = true;  # PulseAudio compatibility
    jack.enable = false;  # optional
  };

  # Enable Bluetooth daemon
  services.blueman.enable = true;

  # Power management for battery life
  services.tlp = {
    enable = true;
    settings = {
      PLATFORM_PROFILE_ON_BAT = "low-power";
      CPU_SCALING_MAX_FREQ_ON_BAT = 2400000;
      CPU_SCALING_MAX_FREQ_ON_AC = 4200000;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  services.fprintd.enable = true;

  my.power-tune.enable = true;

  # Suspend-then-hibernate: sleep now, hibernate after 2h of sleep
  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "7200";
  };

  # Lid switch: when closed, drop the internal display so only the external
  # monitor stays active (instead of logind suspending or leaving both outputs on).
  services.logind.settings.Login.HandleLidSwitch = "ignore";

  services.acpid = {
    enable = true;
    lidEventCommands = ''
      as_user() {
        ${pkgs.util-linux}/bin/runuser -u filipe -- env XDG_RUNTIME_DIR=/run/user/1000 "$@"
      }

      run_hyprctl() {
        local sig
        sig=$(ls /run/user/1000/hypr/ 2>/dev/null | grep -v -E '\.' | head -1)
        [ -n "$sig" ] || return 0
        as_user env HYPRLAND_INSTANCE_SIGNATURE="$sig" \
          ${pkgs.hyprland}/bin/hyprctl "$@"
      }

      external_present() {
        run_hyprctl monitors all | grep -E '^Monitor ' | grep -vq 'eDP-1'
      }

      case "$1" in
        *close*)
          if external_present; then
            run_hyprctl keyword monitor eDP-1, disable
            as_user ${pkgs.systemd}/bin/systemctl --user restart waybar
          else
            ${pkgs.systemd}/bin/loginctl suspend
          fi
          ;;
        *open*)
          run_hyprctl keyword monitor eDP-1, preferred, 0x0, 1
          as_user ${pkgs.systemd}/bin/systemctl --user restart waybar
          ;;
      esac
    '';
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
 }
