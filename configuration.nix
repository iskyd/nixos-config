{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/nvidia.nix
    ./modules/system.nix
    ./modules/hyprland.nix
    <home-manager/nixos>
  ];

  nix.optimise.automatic = true;
  nix.settings.auto-optimise-store = true;

  nixpkgs.config.allowUnfree = true;

  # Boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Swap
  swapDevices = [ { device = "/dev/nvme0n1p2"; } ];

  # Networking
  networking.hostName = "brisingr";
  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager-openvpn ];
  };

  # Docker
  virtualisation.docker.enable = true;

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  services.logind = {
    settings = {
      Login = {
        HandleLidSwitchDocked = "ignore";
        HandleLidSwitchExternalPower = "ignore";
        HandleLidSwitch = "ignore";
      };
    };
  };

  # User account
  users.users.iskyd = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "docker"];
    shell = pkgs.zsh;
  };

  # Home Manager
  home-manager.users.iskyd = import ./home.nix;

  system.stateVersion = "25.11";

  environment.systemPackages = with pkgs; [
    psmisc
    polkit_gnome
  ];
}
