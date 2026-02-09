{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "temperature" "battery" "tray" ];

        "hyprland/workspaces" = {
          format = "{id}";
        };
        
        "hyprland/window" = {
          format = "{}";
          max-length = 50;
        };

        clock = {
          format = "🕐 {:%H:%M}";
          format-alt = "📅 {:%Y-%m-%d}";
        };

        cpu = {
          format = "💻 {usage}%";
        };

        memory = {
          format = "🧠 {percentage}%";
        };

        temperature = {
          format = "🌡️ {temperatureC}°C";
          critical-threshold = 80;
        };

        battery = {
          format = "🔋 {capacity}%";
          format-charging = "⚡ {capacity}%";
        };

        network = {
          format-wifi = "📶 {essid}";
          format-ethernet = "🌐 Connected";
          format-disconnected = "❌ Offline";
          on-click = "nm-connection-editor";
        };

        pulseaudio = {
          format = "🔊 {volume}%";
          format-muted = "🔇 Muted";
        };

        tray = {
          icon-size = 20;
          spacing = 10;
          show-passive-items = true;  # Add this
        };
      };
    };
      style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
      }

      window#waybar {
        background-color: rgba(26, 27, 38, 0.9);
        color: #cdd6f4;
      }

      #cpu,
      #memory,
      #temperature,
      #battery,
      #network,
      #pulseaudio,
      #clock {
        padding: 0 12px;
        margin: 4px 2px;
        border-radius: 8px;
        background-color: #313244;
        color: #cdd6f4;
      }

      #cpu         { background-color: #89b4fa; color: #1e1e2e; }
      #memory      { background-color: #cba6f7; color: #1e1e2e; }
      #temperature { background-color: #fab387; color: #1e1e2e; }
      #battery     { background-color: #a6e3a1; color: #1e1e2e; }
      #network     { background-color: #94e2d5; color: #1e1e2e; }
      #pulseaudio  { background-color: #f5c2e7; color: #1e1e2e; }
      #clock       { background-color: #f38ba8; color: #1e1e2e; }

      #window {
        margin: 4px 10px;
        padding: 0 10px;
        color: #89b4fa;
      }

      #workspaces button {
        padding: 0 10px;
        margin: 0 2px;
        border-radius: 8px;
        background-color: #313244;
        color: #cdd6f4;
      }

      #workspaces button.active {
        background-color: #89b4fa;
        color: #1e1e2e;
      }

      /* Tray styling */
      #tray {
        padding: 0 12px;
        margin: 4px 2px;
        border-radius: 8px;
        background-color: #313244;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }

      #tray menu {
        background-color: #1e1e2e;
        border: 2px solid #89b4fa;
        border-radius: 8px;
        padding: 5px;
      }

      #tray menu menuitem {
        background-color: transparent;
        color: #cdd6f4;
        padding: 5px 10px;
        border-radius: 5px;
      }

      #tray menu menuitem:hover {
        background-color: #313244;
      }

      #tray menu separator {
        background-color: #45475a;
      }
    '';
  };
}
