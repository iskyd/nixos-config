{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/nvidia.nix
    ./modules/system.nix
    ./modules/hyprland.nix
    <home-manager/nixos>
  ];

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

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # User account
  users.users.iskyd = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
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
