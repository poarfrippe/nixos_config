{ config, pkgs, ... }:

{
  imports = [
    ./home/i3.nix
    ./home/nvim.nix
  ];

  home = {
    username = "fripp";
    homeDirectory = "/home/fripp";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "25.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = with pkgs; [
      hello
      iotop          # io monitoring
      iftop          # network monitoring
      calibre        # ebook manager
      logseq
      spotify
      arduino-ide
      protonvpn-gui
      qbittorrent
      vlc
      libreoffice-qt
      obsidian
      kdePackages.okular
      kdePackages.filelight
      nerd-fonts.jetbrains-mono
      vscode
      xss-lock
      rofi
      pulseaudioFull
      picom            # compositor windows
      pasystray        # pulseaudio system tray
      feh              # wallpaper
      networkmanagerapplet
      maim
      xclip
      haskellPackages.greenclip
      zip
      unzip
      webcamoid
      #cargo
      #rustc
      fd #needed by telescope
      ripgrep #needed by telescope
      libimobiledevice
      ifuse # use "ifuse /tmp/iphone" to mount and "fusermount -u /temp/iphone" to unmont
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/fripp/etc/profile.d/hm-session-vars.sh
    #
    sessionVariables = {
      # EDITOR = "emacs";
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs = {
    home-manager.enable = true;

    btop = {
      enable = true;
      settings = {
        color_theme = "gruvbox_dark_v2";
        vim_keys = true;
      };
    };

    git = {
      enable = true;
      settings = {
        user = {
          email = "philipp.gruber02@gmail.com";
          name = "fripp";
        };
        safe.directory = [ "/etc/nixos" ];
      };
    };

    alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        font = {
          size = 12;
          # draw_bold_text_with_bright_colors = true;
        };
        scrolling.multiplier = 5;
        selection.save_to_clipboard = true;
      };
    };

    firefox.enable = true;
    
    vim = {
      enable = true;
      settings = {
          shiftwidth = 2;
          tabstop = 2;
          expandtab = true;
        };
      extraConfig = ''
          set clipboard=unnamedplus
        '';
      };
  };

  xfconf.settings = {
    "xfce4-session" = {
      "general/LockCommand" = "loginctl lock-session";
    };
  };

}
