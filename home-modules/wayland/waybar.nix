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
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "temperature" "battery" ];

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
        };

        pulseaudio = {
          format = "🔊 {volume}%";
          format-muted = "🔇 Muted";
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

      #cpu, #memory, #temperature, #battery, #network, #pulseaudio, #clock {
        padding: 0 12px;
        margin: 4px 2px;
        border-radius: 8px;
        background-color: #313244;
        color: #cdd6f4;
      }

      #cpu { background-color: #89b4fa; color: #1e1e2e; }
      #memory { background-color: #cba6f7; color: #1e1e2e; }
      #temperature { background-color: #fab387; color: #1e1e2e; }
      #battery { background-color: #a6e3a1; color: #1e1e2e; }
      #network { background-color: #94e2d5; color: #1e1e2e; }
      #pulseaudio { background-color: #f5c2e7; color: #1e1e2e; }
      #clock { background-color: #f38ba8; color: #1e1e2e; }

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
    '';
  };
}
