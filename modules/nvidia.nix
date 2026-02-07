{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
}
