{ config, lib, pkgs, ... }:

let
  mod = "Mod4";
in {
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;
      terminal = "alacritty";
      fonts = {
        names = [ "DejaVu Sans Mono" "FontAwesome 6" ];
        size = 11.0;
      };
      defaultWorkspace = "workspace number 1";

      startup = [
        { command = "${pkgs.feh}/bin/feh --bg-scale ${config.home.homeDirectory}/Pictures/wallpapers"; notification = false; }
        { command = "--no-startup-id ${pkgs.xss-lock}/bin/xss-lock --transfer-sleep-lock -- i3lock  -i /${config.home.homeDirectory}/Pictures/wallpapers/frutigerAeroWallpaper.png --nofork --show-failed-attempts"; notification = false; }
      ];

      keybindings = lib.mkOptionDefault {
        "${mod}+p" = "exec ${pkgs.i3}/bin/i3-dmenu-desktop";
        "${mod}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
        "${mod}+x" = "exec sh -c '${pkgs.maim}/bin/maim -s | xclip -selection clipboard -t image/png'";
        "${mod}+l" = "exec loginctl lock-session";

        "${mod}+v" = "exec rofi -modi 'clipboard:${pkgs.haskellPackages.greenclip}/bin/greenclip print' -show clipboard";

        # Move
        "${mod}+Shift+j" = "move left";
        "${mod}+Shift+k" = "move down";
        "${mod}+Shift+l" = "move up";
        "${mod}+Shift+semicolon" = "move right";

        # My multi monitor setup
        "${mod}+m" = "move workspace to output DP-2";
        "${mod}+Shift+m" = "move workspace to output DP-5";
      };

      bars = [
        {
          position = "top";
          # statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${./i3status-rust.toml}";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-top.toml";
          fonts = {
            names = [ "JetBrainsMono Nerd Font" "monospace" ];
            size = 10.0;
          };
        }
      ];
    };
  };

  programs.i3status-rust = {
    enable = true;
    bars.top = {
      icons = "material-nf";
      blocks = [
        {
          block = "time";
          interval = 60;
          format = " $icon { $timestamp.datetime(f:'%a %d/%m %H:%M') } ";
        }
        {
          block = "battery";
          interval = 10;
          device = "BAT0";
          format = " $icon BAT0:$percentage $time ";
          click = [
            {
              button = "left";
              cmd = "xfce4-power-manager-settings";
            }
          ];
        }
        {
          block = "battery";
          interval = 10;
          device = "BAT1";
          format = " $icon BAT1:$percentage $time ";
          click = [
            {
              button = "left";
              cmd = "xfce4-power-manager-settings";
            }
          ];
        }
        {
          block = "cpu";
          interval = 5;
          format = " $icon $utilization ";
        }
        {
          block = "memory";
          interval = 5;
          format = " $icon $mem_used_percents ";
        }
      ];
    };
  };
}
