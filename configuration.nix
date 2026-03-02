{ config, lib, pkgs, ... }:

let
  sops-commit = "d8be5ea4cd3bc363492ab5bc6e874ccdc5465fe4";
  sops-nix-src = builtins.fetchTarball {
    url = "https://github.com/Mic92/sops-nix/archive/${sops-commit}.tar.gz";
    # This is the correct hash for that specific commit
    sha256 = "1d6gg84ni6p411187rgzm7ad0p384wn76k3ackjimxi11m1a8z30";
  };
in
{
  imports = [
    "${sops-nix-src}/modules/sops"
    ./hardware-configuration.nix
    ./modules/nvidia.nix
    ./modules/system.nix
    ./modules/hyprland.nix
    ./modules/sops.nix
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
