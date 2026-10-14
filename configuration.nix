# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  systemd.user.services.greenclip = {
    description = "greenclip clipboard manager";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.haskellPackages.greenclip}/bin/greenclip daemon";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  networking = {
    hostName = "Nixosbtw";
    networkmanager = {
    	enable = true;
        plugins = with pkgs; [
      	  networkmanager-openvpn
        ];
    };
    firewall = {
      checkReversePath = false;
      allowedUDPPorts = [
        53317
      ];
      allowedTCPPorts = [
        53317
      ];
    };
  };

  time.timeZone = "Europe/Vienna";

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_AT.UTF-8";
      LC_IDENTIFICATION = "de_AT.UTF-8";
      LC_MEASUREMENT = "de_AT.UTF-8";
      LC_MONETARY = "de_AT.UTF-8";
      LC_NAME = "de_AT.UTF-8";
      LC_NUMERIC = "de_AT.UTF-8";
      LC_PAPER = "de_AT.UTF-8";
      LC_TELEPHONE = "de_AT.UTF-8";
      LC_TIME = "de_AT.UTF-8";
    };
  };

  services = {
    displayManager = {
      defaultSession = "xfce+i3";
      #lightdm.enable = true;
    };
    xserver = {
      enable = true;
      windowManager.i3.enable = true;
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      xkb = {
        layout = "us";
        options = "ctrl:nocaps";
        variant = "intl";
      };
      videoDrivers = [ "modesetting" ];
    };
    picom = {
      enable = true;
      vSync = true;
      backend = "glx";   # or "xrender" if glx causes issues
    };
    printing.enable = true;
    openssh.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    usbmuxd.enable = true;
    openvpn.servers = {
      deutschlandVPN  = { 
        config = "config /home/fripp/openVpn/deutschlandVPN.conf";
        updateResolvConf = true;
	autoStart = false;
      };
    };
    udev.extraRules = ''
	  # Xilinx platform cable / onboard FTDI (Digilent, Basys3, Arty, Nexys etc.)
	  SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6010", MODE="0666"
	  SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6014", MODE="0666"
	  SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6011", MODE="0666"

	  # Xilinx Platform Cable USB / USB II
	  SUBSYSTEM=="usb", ATTR{idVendor}=="03fd", MODE="0666"

	  # Digilent
	  SUBSYSTEM=="usb", ATTR{idVendor}=="1443", MODE="0666"
	'';
  };

  console.keyMap = "us";

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.i3lock.enable = true;
  };

  programs.dconf.enable = true;
  programs.nix-ld.enable = true;

  environment = {
    xfce.excludePackages = with pkgs; [
      mousepad
      parole
      # ristretto
      xfce4-appfinder
      # xfce4-notifyd
      # xfce4-screenshooter
      # xfce4-session
      # xfce4-settings
      xfce4-taskmanager
      xfce4-terminal
      xfce4-screensaver
    ];
    systemPackages = with pkgs; [
      vim
      wget
      cowsay
      sl
      git
      fzf
      python3
      gnome-keyring
      polkit_gnome
      fwupd # usage: fwupdmgr get-devices; fwupdmgr refresh; fwupdmgr get-updates; fwupdmgr update;
      file
      openvpn
    ];
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    pulseaudio = true;
  };

  users.users.fripp = {
    isNormalUser = true;
    description = "Philipp Gruber";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users."fripp" = import ./home.nix;
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings = {
        General = {
          # Shows battery charge of connected devices on supported
          # Bluetooth adapters. Defaults to 'false'.
          Experimental = true;
          # When enabled other devices can connect faster to us, however
          # the tradeoff is increased power consumption. Defaults to 'false'.
          FastConnectable = true;
        };
        Policy = {
          # Enable all controllers when they are found. This includes
          # adapters present on start as well as adapters that are plugged
          # in later on. Defaults to 'true'.
          AutoEnable = true;
        };
      };
    };
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver  # iHD — correct driver for UHD 620
        libva-vdpau-driver    # fallbacks
        libvdpau-va-gl 
      ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
