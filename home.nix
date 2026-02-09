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
