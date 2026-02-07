{ config, pkgs, lib, ... }:

{
  imports = [
    ./home-modules/programs/emacs.nix
    ./home-modules/programs/git.nix
    ./home-modules/programs/tmux.nix
    ./home-modules/programs/zsh.nix
    ./home-modules/wayland/hyprland.nix
    ./home-modules/wayland/waybar.nix
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

    # Browser
    brave

    # Fonts
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
  ];

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
