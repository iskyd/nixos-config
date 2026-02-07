{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/nvidia.nix
    ./modules/system.nix
    ./modules/hyprland.nix
    <home-manager/nixos>
  ];

  # Boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Swap
  swapDevices = [ { device = "/dev/nvme0n1p2"; } ];

  # Networking
  networking.hostName = "brisingr";
  networking.networkmanager.enable = true;

  # User account
  users.users.iskyd = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.zsh;
  };

  # Home Manager
  home-manager.users.iskyd = import ./home.nix;

  system.stateVersion = "25.11";
}
