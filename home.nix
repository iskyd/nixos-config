{ config, pkgs, lib, ... }:

{
  imports = [
    ./home-modules/programs/emacs.nix
    ./home-modules/programs/git.nix
    ./home-modules/programs/tmux.nix
    ./home-modules/programs/zsh.nix
    ./home-modules/wayland/hyprland.nix
    ./home-modules/wayland/waybar.nix
    ./home-modules/wayland/wofi.nix
  ];

  home.username = "iskyd";
  home.homeDirectory = "/home/iskyd";
  home.stateVersion = "25.11";

  # Packages
  home.packages = with pkgs; [
    # Wayland utilities
    dunst
    wl-clipboard
    grim
    slurp
    swww

    # Terminal
    alacritty

    # File manager
    yazi

    # CLI utilities
    gping
    dysk
    git-graph
    ripgrep
    pass
    fastfetch
    fzf
    fzy
    difftastic
    direnv
    eza
    zoxide
    sqlite
    lldb
    just
    bruno

    # Fonts
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg

    # Social
    telegram-desktop

    # Development
    godot
    blender
    postgresql
    awscli2
    opencode

    # Browser
    (pkgs.writeShellScriptBin "brave" ''
      exec ${pkgs.brave}/bin/brave \
        "$@"
    '')

    (pkgs.writeShellScriptBin "brave-no-gpu" ''
      exec ${pkgs.brave}/bin/brave \
        --disable-gpu \
        "$@"
    '')

    # Netork
    networkmanagerapplet
    wireguard-tools

    # Setup monitor
    (pkgs.writeShellScriptBin "hypr-monitor-setup" ''
      sleep 1  # Wait for monitors to be detected
      if hyprctl monitors | grep -q "HDMI-A-1"; then
        # HDMI connected - mirror at 2560x1440
        hyprctl keyword monitor eDP-1,2560x1440@60,auto,1
        hyprctl keyword monitor HDMI-A-1,2560x1440@60,auto,1,mirror,eDP-1
      else
        # No HDMI - use laptop at native resolution
        hyprctl keyword monitor eDP-1,1920x1200@165,auto,1
      fi
    '')
  ];

  xdg.desktopEntries = {
    brave = {
      name = "Brave Browser";
      genericName = "Web Browser";
      exec = "brave %U";
      terminal = false;
      categories = [ "Application" "Network" "WebBrowser" ];
      mimeType = [ "text/html" "text/xml" ];
      icon = "${pkgs.brave}/share/icons/hicolor/128x128/apps/brave-browser.png";
    };
  
    brave-drm = {
      name = "Brave Browser (No GPU)";
      genericName = "Web Browser for DRM Content No GPU";
      exec = "brave-no-gpu %U";
      terminal = false;
      categories = [ "Application" "Network" "WebBrowser" ];
      mimeType = [ "text/html" "text/xml" ];
      icon = "${pkgs.brave}/share/icons/hicolor/128x128/apps/brave-browser.png";
      comment = "For Udemy, Netflix, and other DRM platforms";
    };
  };

  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
        identityFile = "~/.ssh/id_rsa";
      };

      "online-*.staging online-*.prod online-*.core backoffice-*.staging backoffice-*.prod logstash.staging logstash.prod bitcoind-*.core online-*.pricingstaging online-*.hype online-*.btpnowstaging online-*.hypestagingv2 backoffice-*.hypestagingv2 backoffice-*.hype logstash.hype support-*.prod" = {
        user = "mattia_careddu";
        identityFile = "~/.ssh/id_rsa";
        
        extraOptions = {
          "CanonicalDomains" = "aws.conio.com";
          "CanonicalizeHostname" = "yes";
        };
      };
    };
  };
  
  # Alacritty
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "MesloLGS Nerd Font";
        size = 14.0;
      };
      window.opacity = 0.8;
    };
  };

  # Session Variables
  home.sessionVariables = {
    EDITOR = "${lib.getExe' pkgs.emacs "emacs"} -nw -q";
    GOPRIVATE = "bitbucket.org/squadrone";
    NIXOS_OZONE_WL = "1";
  };
}
